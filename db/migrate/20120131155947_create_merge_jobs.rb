class CreateMergeJobs < ActiveRecord::Migration
  def change
    create_table :merge_jobs do |t|
      t.string :hdfs_src
      t.string :dest_server
      t.string :dest_path

      t.timestamps
    end
  end
end
