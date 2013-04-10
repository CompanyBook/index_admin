class AddServerIdToSolrServer < ActiveRecord::Migration
  def change
    add_column :solr_servers, :server_id, :int
  end
end
