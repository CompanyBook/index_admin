require 'yaml'
require_relative 'logging'

class RemoteServer
  include Logging

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
    attr_accessor :size, :path, :full_path

    def initialize(size, path)
      @size = "%8.1fG" % [size.to_f / (1024*1024*1024)]
      @path = path.split(/\/hjellum\//).last
      @full_path = path
    end

    def to_s
      "#{path} - #{size}"
    end
  end

  @@cmd_cache = {}

  def initialize(server=nil, name=nil, copy_script_path=nil)
    @server = server || 'companybook-002.servers.eqx.misp.co.uk'
    @user = name || 'rlind'
    @copy_script_path = copy_script_path || '/home/rlind/hdfs_copy_solr_index'
    @copy_script_path = '~/Source/hdfs_copy_solr_index' if @server == 'localhost' # for testing
    log.info "initialize"
    log.info "@server=#{@server} user=#{@user} copy_script_path=#{@copy_script_path}"
  end

  def run(cmd)
    return %x[#{cmd}] if @server == 'localhost' # for testing

    cache_key = [@server,cmd].join('_')
    #return @@cmd_cache[cache_key] if(@@cmd_cache[cache_key])

    stdout = ""
    msg = "SSH:'#{@user}' cmd:#{cmd}"
    puts msg
    log.info "run: #{msg}"
    server = @server
    server = 'companybook-002.servers.eqx.misp.co.uk' if cmd[0..5] == 'hadoop'
    Net::SSH.start(server, @user) do |ssh|
      ssh.exec!(cmd) do |channel, stream, data|
        stdout << data if stream == :stdout
      end
    end
    log.info "result:#{stdout[0..10]}..."
    @@cmd_cache[cache_key] = stdout
    stdout
  end

  def run_and_return_lines(cmd)
    run(cmd).split("\n")
  end

  def available_space
    result = run_and_return_lines('df -h  | grep /srv/ssd | awk \'{print $2" "$3" "$4" "$6 }\'')
    puts result
    result.collect { |a| ServerHdSpaceInfo.new(*a.split(/\s+/)) }
  end

  def available_space_as_map
    @avail_space ||= available_space.inject({}) { |map, item| map[item.location]=item.size; map }
  end

  def solr_index_locations
    #result = run_and_return_lines('du -h --max-depth=5 /data  | sort -k2')
    result = run_and_return_lines('du -h /srv  | sort -k2')
    paths = result.collect { |line| line.split(/\s+/) }

    total_avail_space = available_space_as_map.collect { |k, v| v.to_i }.inject { |sum, x| sum + x }
    root = RemoteServer::FileTree.new(paths.first[1], paths.first[0], "#{total_avail_space}G")
    paths.drop(1).each do |size, path|
      root.add(path, size, available_space_as_map[path])
    end
    root
  end

  def hdfs_solr_index_paths(src_path)
    result = run_and_return_lines("hadoop fs -du /#{src_path} | sort -k2 | grep #{src_path}")
    result.collect { |line| HDFSFileInfo.new(*line.split(/\s+/)) }
  end

  def run_solr_index_copy_and_merge(opts)
    #opts =
    #    {
    #        :simulate => args[:simulate] || false,
    #        :verify => false,
    #        #:name => 'news20110820_all',
    #        :hadoop_src => args[:hadoop_src],
    #        :copy_dst => args[:copy_dst],
    #        :max_merge_size => args[:max_merge_size] || '150G',
    #        :dst_distribution => args[:dst_distribution],
    #        :solr_version => args[:solr_version],
    #        :solr_lib_path => args[:solr_lib_path]
    #    }
    #opts[:core_prefix] = args[:core_prefix] if args[:core_prefix]

    File.open("go.yml", 'w:UTF-8') { |out| YAML::dump(opts, out) }
    cmd = "scp go.yml #{@user}@#{@server}:#{@copy_script_path}"
    %x[#{cmd}]

    index_name = opts[:index_name] || opts[:hadoop_src].split('/').last
    #run("cd #{@copy_script_path}; nohup ~/.rvm/bin/rvm 1.9.2-p290@hdfs_copy_solr_index do ruby go.rb go.yml > /dev/null 2> #{index_name}.err < /dev/null &")
    run("cd #{@copy_script_path}; ruby go.rb go.yml > /dev/null 2> #{index_name}.err < /dev/null &")
  end

  def log_output(index_name)
    log.info "log_output index_name #{index_name} @copy_script_path=#{@copy_script_path}"
    run("cd #{@copy_script_path}; cat #{index_name}.log")
  end

  def is_running(index_name)
    last_line = log_output(index_name).split("\n").last
    log.info "last_line #{last_line}"
    return false if last_line == nil
    return false if last_line.match(/No such file/)
    return false if last_line == 'done!'
    return false if last_line.match /with gemset hdfs_copy_solr_index/
    true
  end

  def running_status(index_name)
    run("cd #{@copy_script_path}; cat #{index_name}.running; grep -v 'WARN conf.Configuration' #{index_name}.err")
  end

  def find_job_id(hdfs_source_path)
    result = run_and_return_lines("hadoop fs -du #{hdfs_source_path}/_logs/history/*.xml | awk '{print $2 }'").last
    log.info "job id for #{hdfs_source_path} result:#{result}"
    result.match(/job_\d+_\d+/).to_s if result
  end

  def find_job_solr_schema(hdfs_source_path)
    cmd = "hadoop fs -cat #{hdfs_source_path}/_logs/history/*.xml | grep 'solr\\.'"
    result =  run_and_return_lines(cmd)
    conf_dir = result.find { |line| line.match /solr\.conf\.dir/ }.match(/<value>(.+?)<\/value>/)[1]
    log.info "conf_dir:#{conf_dir}"
    schema_file = result.find { |line| line.match /solr\.schema\.file/ }.match(/<value>(.+?)<\/value>/)[1]
    log.info "schema_file:#{schema_file}"

    home_dir =  find_user_home_dir(hdfs_source_path)
    "/#{home_dir}#{conf_dir}/#{schema_file}"
  end

  def find_user_home_dir(hdfs_source_path)
    hdfs_source_path.match /user\/\w+\//
  end

  def copy_schema_files(hdfs_source_path, server_dest_path)
    hdfs_schema_path = find_job_solr_schema(hdfs_source_path)
    run("hadoop fs -copyToLocal /user/rlind/solrindex/solr4/companies/conf #{server_dest_path}/conf")
    run("hadoop fs -copyToLocal #{hdfs_schema_path} #{server_dest_path}/conf/schema.xml")
  end

  def check_solr_installation(path, version)
    result = run_and_return_lines("ls #{path} | grep '#{version}'")
    is_ok = result.find_all { |line| line.match /lucene-core/ }.size == 1
    if is_ok
      result = ['solr *.jar files for merge found :)']
    else
      result << 'Could not find solr *.jar files needed for merge'
    end
    [is_ok, result.join("\n")]
  end

  def create_core(port, dest_path, index_name)
    log.info "create_core:server:#{@server} port:#{port} index_name:#{index_name} dest_path:#{dest_path}"
    result = []
    action = "curl 'http://#{@server}:#{port}/solr/admin/cores?action=CREATE&name=#{index_name}&instanceDir=#{dest_path}&persist=true'"
    result << "\n" + action
    result << "\n" + run(action)
    result
  end

  def remove_core(server, port, core_name)
    result = []
    action = "curl 'http://#{server}:#{port}/solr/admin/cores?action=UNLOAD&core=#{core_name}'"
    result << "\n" + action
    result << "\n" + run(action)
    result
  end
end
