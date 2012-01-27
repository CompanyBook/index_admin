require 'remote_server'

class Server < ActiveRecord::Base
  def show_tree
    RemoteServer.new.solr_index_locations
  end
end
