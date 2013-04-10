require 'spec_helper'

describe "solr_servers/index.html.erb" do
  before(:each) do
    assign(:solr_servers, [
      stub_model(SolrServer,
        :name => "Name",
        :port => "Port",
        :version => "Version"
      ),
      stub_model(SolrServer,
        :name => "Name",
        :port => "Port",
        :version => "Version"
      )
    ])
  end

  it "renders a list of solr_servers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Port".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Version".to_s, :count => 2
  end
end
