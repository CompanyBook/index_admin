class AddSolrVersionToMergeJobs < ActiveRecord::Migration
  def change
    add_column :merge_jobs, :solr_version, :string
  end
end
