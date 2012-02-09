class AddSolrLibPathToMergeJobs < ActiveRecord::Migration
  def change
    add_column :merge_jobs, :solr_lib_path, :string
  end
end
