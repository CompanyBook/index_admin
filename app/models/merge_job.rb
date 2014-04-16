require 'remote_server'

class MergeJob < ActiveRecord::Base
  def remote_server
    @server ||= RemoteServer.new(dest_server)
  end

  def is_running

    running = remote_server.is_running(index_name)
    puts "MergeJob - is_running = #{running}"
    running
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
    part = 0
    dest_paths = dest_path.split(",").map { |it| it.gsub(/\s+/, "") }
    if dest_paths.size > 1
      dest_paths = dest_paths.map { |it| "#{it}_#{part += 1}" }
    end

    args = {simulate: false,
            verify: false,
            hadoop_src: hdfs_src,
            copy_dst: copy_dst,
            max_merge_size: '400',
            dst_distribution: dest_paths,
            index_name: index_name,
            solr_version: solr_version || "4.3.0",
            solr_lib_path: solr_lib_path || "/usr/local/solr/solr-3-6-0-jar-files/WEB-INF/lib",
            job_id: job_id,
            config_src_folder: solr_schema,
            dest_server: dest_server
    }

    args[:name] = "#{hdfs_src.split('/').last}" if dest_paths.size > 1
    remote_server.run_solr_index_copy_and_merge(args)
  end
end
