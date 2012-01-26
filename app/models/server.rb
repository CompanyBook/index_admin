require 'remote_login'

class Server < ActiveRecord::Base
  def show_tree
    RemoteLogin.new.solr_index_locations
  end
end
