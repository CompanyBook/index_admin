class CreateSolrServers < ActiveRecord::Migration
  def change
    create_table :solr_servers do |t|
      t.string :name
      t.string :port
      t.string :version

      t.timestamps
    end
  end
end
