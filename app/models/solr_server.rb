require 'solr_core_admin'

class SolrServer < ActiveRecord::Base
  belongs_to :server

  def solr_core_admin
    @solr_core_admin ||= SolrCoreAdmin.new(name, port, id)
  end
end
