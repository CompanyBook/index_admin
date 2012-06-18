require 'spec_helper'

describe "solr_servers/show.html.erb" do
  before(:each) do
    @solr_server = assign(:solr_server, stub_model(SolrServer,
      :name => "Name",
      :port => "Port",
      :version => "Version"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Port/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Version/)
  end
end
