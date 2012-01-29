require 'remote_server'

class Server < ActiveRecord::Base
  def solr_index_locations
    @solr_index_locations ||= RemoteServer.new(name).solr_index_locations
  end
end
