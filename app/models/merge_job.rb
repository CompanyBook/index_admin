require 'remote_server'

class MergeJob < ActiveRecord::Base
  def run_solr_index_copy_and_merge(hdfs_src_path, server_dest_path)
    RemoteServer.new(dest_server).run_solr_index_copy_and_merge(hdfs_src_path, server_dest_path)
  end
end
