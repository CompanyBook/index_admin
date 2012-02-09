class AddSolrSchemaMergeJobs < ActiveRecord::Migration
  def change
    add_column :merge_jobs, :solr_schema, :string
  end
end
