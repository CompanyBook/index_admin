class CreateHdfsPaths < ActiveRecord::Migration
  def change
    create_table :hdfs_paths do |t|
      t.string :path

      t.timestamps
    end
  end
end
