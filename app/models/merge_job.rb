require 'remote_server'

class MergeJob < ActiveRecord::Base
  def is_running
    false
  end

  def output
    RemoteServer.new(dest_server).log_output
  end

  def run_solr_index_copy_and_merg
    args = { simulate: true,
             hadoop_src: hdfs_src,
             copy_dst: dest_path,
             max_merge_size: '150G',
             dst_distribution: [copy_dst]  }

    RemoteServer.new(dest_server).run_solr_index_copy_and_merge(args)
  end
end
