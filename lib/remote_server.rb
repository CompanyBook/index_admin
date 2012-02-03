require 'net/ssh'
require 'yaml'

class RemoteServer
  ServerHdSpaceInfo = Struct.new(:size, :used, :avail, :location)

  class FileTree
    attr_reader :path, :name, :size, :children
    attr_accessor :parent, :avail_space

    def initialize(path, size='0', avail_space='0')
      @path = path
      @size = size
      @avail_space = avail_space
      @name = path.split("/").last
      @children = []
      @parent = nil
    end

    def add(path, size='0', avail_space='0')
      root = find(path) || self
      new = FileTree.new(path, size, avail_space)
      new.parent=root
      root.children << new
      new
    end

    def find(path)
      path_parts = path.split("/")[0..-2]
      find_children(path_parts, children)
    end

    def find_children(path_parts, children)
      children.each do |child|
        child_parts = child.path.split("/")
        if child_parts.length < path_parts.length
          found = find_children(path_parts, child.children)
          return found if found
        end
        return child if path_parts == child_parts
      end
      nil
    end

    def to_s
      "#{path} - #{children}"
    end

    def print_as_tree
      to_string("")
    end

    def to_string(indent)
      children.
          map { |child| child.to_string(indent + " ") }.
          reduce("#{indent}#{name}(#{size}/#{avail_space})\n", :+)
    end
  end

  class HDFSFileInfo
    attr_accessor :size, :path

    def initialize(size, path)
      @size = "%8.1fG" % [size.to_f / (1024*1024*1024)]
      @path = path.split(/\/hjellum/).last
    end

    def to_s
      "#{path} - #{size}"
    end
  end

  def initialize(server='datanode29.companybook.no', name='hjellum', copy_script_path='~/hdfs_copy_solr_index')
    @server = server
    @user = name
    @copy_script_path = copy_script_path
    @copy_script_path = '~/Source/hdfs_copy_solr_index' if @server == 'localhost' # for testing
  end

  def run(cmd)
    return %x[#{cmd}] if @server == 'localhost' # for testing

    stdout = ""
    Net::SSH.start(@server, @name) do |ssh|
      ssh.exec!(cmd) do |channel, stream, data|
        stdout << data
      end
    end
    stdout
  end

  def run_and_return_lines(cmd)
    run(cmd).split("\n")
  end

  def available_space
    result = run_and_return_lines('df -h  | grep /data/ | awk \'{print $2" "$3" "$4" "$6 }\'')
    result.collect { |a| ServerHdSpaceInfo.new(*a.split(/\s+/)) }
  end

  def available_space_as_map
    @avail_space ||= available_space.inject({}) { |map, item| map[item.location]=item.size; map }
  end

  def solr_index_locations
    result = run_and_return_lines('du /data -h --max-depth=5 | sort -k2')
    paths = result.collect { |line| line.split(/\s+/) }

    total_avail_space = available_space_as_map.collect { |k, v| v.to_i }.inject { |sum, x| sum + x }
    root = RemoteServer::FileTree.new(paths.first[1], paths.first[0], "#{total_avail_space}G")
    paths.drop(1).each do |size, path|
      root.add(path, size, available_space_as_map[path])
    end
    root
  end

  def hdfs_solr_index_paths
    result = run_and_return_lines('hadoop fs -du /user/hjellum/solrindex | sort -k2 | grep user/hjellum/solrindex')
    result.collect { |line| HDFSFileInfo.new(*line.split(/\s+/)) }
  end

  def run_solr_index_copy_and_merge(args)
    opts =
        {
            :simulate => args[:simulate] || false,
            :verify => false,
            #:name => 'news20110820_all',
            :core_prefix => args[:core_prefix],
            :hadoop_src => args[:hadoop_src],
            :copy_dst => args[:copy_dst],
            :max_merge_size => args[:max_merge_size] || '150G',
            :dst_distribution => args[:dst_distribution]
        }
    opts[:job_id] = args[:job_id] if args[:job_id]

    File.open("go.yml", 'w:UTF-8') { |out| YAML::dump(opts, out) }
    cmd = "scp go.yml #{@server}:#{@copy_script_path}"
    %x[#{cmd}]

    run("cd #{@copy_script_path}; nohup ruby go.rb go.yml > foo.out 2> foo.err < /dev/null &")
  end

  def log_output
    run("cd #{@copy_script_path}; cat log.txt")
  end
end