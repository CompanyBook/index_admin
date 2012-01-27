require 'net/ssh'

class RemoteServer
  class FileTree
    attr_reader :path
    attr_reader :name
    attr_accessor :children
    attr_accessor :parent

    def initialize(path)
      @path = path
      @name = path.split("/").last
      @children = []
      @parent = nil
    end

    def add(path)
      root = find(path) || self
      new = FileTree.new(path)
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
      children.map { |child| child.to_string(indent + " ") }.reduce(indent + name + "\n", :+)
    end
  end

  ServerHdSpaceInfo = Struct.new(:size, :used, :avail, :location)

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

  def available_space
    result = run('df  | grep /data/ | awk \'{print $2" "$3" "$4" "$6 }\'')
    result.split("\n").collect { |a| ServerHdSpaceInfo.new(*a.split(/\s+/)) }
  end

  def solr_index_locations
    result = run('tree -difL 4  /data | grep data')
    paths = result.split("\n")

    root = RemoteServer::FileTree.new('/data')
    paths.drop(1).each do |path|
      root.add(path)
    end
    root
  end
end
