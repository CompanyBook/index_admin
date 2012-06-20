require 'open-uri'
require 'json'

class SolrCoreAdmin
  def initialize(server, port)
    @url = "http://#{server}:#{port}/solr/admin/cores?action=STATUS&wt=json"
    puts "NEW #{@url}"
  end

  def servers
    result = open("#{@url}").read
    map = JSON.parse(result)
    map['status'].values
  end

  def server_names
    #servers.collect {|k,v|  "k:#{k} - v:#{v}"  }.join("\n")
    servers.collect {|item|  item['name']}
  end

end