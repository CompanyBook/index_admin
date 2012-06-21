require 'open-uri'
require 'json'

class SolrCoreAdmin
  attr_reader :name, :port
  @@cmd_cache = {}

  def initialize(name, port)
    @name = name
    @port = port
    @url = "http://#{name}:#{port}/solr/admin/cores?action=STATUS&wt=json"
  end

  def servers
    result = @@cmd_cache[@url] ||= open("#{@url}").read
    map = JSON.parse(result)
    map['status'].values
  end

  def server_names
    servers.collect { |item| item['name'] }
  end
end