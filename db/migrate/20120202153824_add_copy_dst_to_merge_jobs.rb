class AddCopyDstToMergeJobs < ActiveRecord::Migration
  def change
    add_column :merge_jobs, :copy_dst, :string
  end
end
