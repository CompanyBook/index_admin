require 'spec_helper'

describe "solr_servers/edit.html.erb" do
  before(:each) do
    @solr_server = assign(:solr_server, stub_model(SolrServer,
      :name => "MyString",
      :port => "MyString",
      :version => "MyString"
    ))
  end

  it "renders the edit solr_server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => solr_servers_path(@solr_server), :method => "post" do
      assert_select "input#solr_server_name", :name => "solr_server[name]"
      assert_select "input#solr_server_port", :name => "solr_server[port]"
      assert_select "input#solr_server_version", :name => "solr_server[version]"
    end
  end
end
