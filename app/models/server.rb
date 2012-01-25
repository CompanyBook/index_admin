require 'remote_login'

class Server < ActiveRecord::Base
  def show_tree
    RemoteLogin.new.show_tree(name)
  end
end
