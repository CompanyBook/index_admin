class AddJobIdToMergeJobs < ActiveRecord::Migration
  def change
    add_column :merge_jobs, :job_id, :string
  end
end
