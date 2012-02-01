require 'remote_server'

class HdfsPath < ActiveRecord::Base
  def hdfs_path_paths
    @hdfs_solr_index_paths ||= RemoteServer.new.hdfs_solr_index_paths
  end
end
