require 'open-uri'
require 'json'

class SolrCoreAdmin
  attr_reader :name, :port, :id

  #@@cmd_cache = {}

  def initialize(name, port, id)
    @name = name
    @port = port
    @id = id
    @url = "http://#{name}:#{port}/solr/admin/cores?action=STATUS&wt=json"

  end

  def servers
    begin
      #result = @@cmd_cache[@url] ||= open("#{@url}").read
      result = open("#{@url}").read
      map = JSON.parse(result)
      @is_ok = true
      return map['status'].values
    rescue Exception => e
      @is_ok = false
      puts "#{@url} have issues and don't return servers \n\n#{e.message}"
    end
  end

  def is_ok
    return @is_ok if @is_ok!=nil
    servers
    @is_ok
  end

  def server_names
    servers.collect { |item| item['name'] }
  end

  def to_s()
    @url
  end
end