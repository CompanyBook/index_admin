require 'remote_server'

class MergeJob < ActiveRecord::Base
  def remote_server
    @server ||= RemoteServer.new(dest_server)
  end

  def is_running
    remote_server.is_running(index_name)
    #Rails.logger.debug test
    #test != 'done!'
  end

  def check_solr_installation(path, version)
    remote_server.check_solr_installation(path, version)
  end

  def output
    remote_server.log_output(index_name)
  end

  def running_status
    remote_server.running_status(index_name)
  end

  def index_name
    hdfs_src.split('/').last
  end

  def run_solr_index_copy_and_merg
    args = {simulate: false,
            verify: false,
            hadoop_src: hdfs_src,
            copy_dst: copy_dst,
            max_merge_size: '150G',
            dst_distribution: dest_path.split(","),
            index_name: index_name,
            solr_version: solr_version || "3.5.0",
            solr_lib_path: solr_lib_path || "/usr/local/solr/solr-3-5-0-jar-files/WEB-INF/lib",
            job_id: job_id,
            config_src_folder: solr_schema
    }

    remote_server.run_solr_index_copy_and_merge(args)
  end
end
