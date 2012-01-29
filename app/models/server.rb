require 'remote_server'

class Server < ActiveRecord::Base
  def show_tree
    RemoteServer.new(name).solr_index_locations
  end
end
