require 'net/ssh'

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

  def initialize(server='datanode29.companybook.no', name='hjellum')
    @server = server
    @user = name
  end

  def run(cmd)
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
    available_space.inject({}) { |map, item| map[item.location]=item.size; map }
  end

  def solr_index_locations
    avail_space = available_space_as_map

    result = run_and_return_lines('du /data -h --max-depth=5 | sort -k2')
    paths = result.collect { |line| line.split(/\s+/) }

    total_avail_space = avail_space.collect { |k, v| v.to_i }.inject { |sum, x| sum + x }
    root = RemoteServer::FileTree.new(paths.first[1], paths.first[0], "#{total_avail_space}G")
    paths.drop(1).each do |size, path|
      root.add(path, size, avail_space[path])
    end
    root
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

  def hdfs_solr_index_paths
    result = run_and_return_lines('hadoop fs -du /user/hjellum/solrindex | sort -k2 | grep user/hjellum/solrindex')
    result.collect { |line| HDFSFileInfo.new(*line.split(/\s+/)) }
  end
end
