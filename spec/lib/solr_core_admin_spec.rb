require_relative '../../lib/solr_core_admin'

describe SolrCoreAdmin do
  it "should get available space" do
    #puts SolrCoreAdmin.new('datanode29.companybook.no','8360').servers
    puts SolrCoreAdmin.new('datanode29.companybook.no','8360').server_names
  end
end