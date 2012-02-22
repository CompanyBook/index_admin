require 'remote_server'

class SolrController < ApplicationController
  def core
  end

  def create
  end

  def copy_schema
    @index_name = params[:hdfs_src].split('/').last
    @hdfs_src = params[:hdfs_src]
    @dest_path = params[:dest_path]
    @dest_server = params[:dest_server]

    remote_server = RemoteServer.new(@dest_server)
    remote_server.copy_schema_files(@hdfs_src, @dest_path)
  end

end
