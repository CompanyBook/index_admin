require 'remote_server'

class Server < ActiveRecord::Base
  has_many :solr_servers

  def remote_server
    @server ||= RemoteServer.new(name)
  end

  def solr_index_locations
    @solr_index_locations ||= remote_server.solr_index_locations
  end

  def find_job_id(hdfs_source_path)
    remote_server.find_job_id(hdfs_source_path)
  end

  def find_job_solr_schema(hdfs_source_path)
    remote_server.find_job_solr_schema(hdfs_source_path)
  end

  def find_solr_server_by_id(id)
    SolrServer.find(id)
  end
end
