require 'spec_helper'

describe "solr_servers/new.html.erb" do
  before(:each) do
    assign(:solr_server, stub_model(SolrServer,
      :name => "MyString",
      :port => "MyString",
      :version => "MyString"
    ).as_new_record)
  end

  it "renders new solr_server form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => solr_servers_path, :method => "post" do
      assert_select "input#solr_server_name", :name => "solr_server[name]"
      assert_select "input#solr_server_port", :name => "solr_server[port]"
      assert_select "input#solr_server_version", :name => "solr_server[version]"
    end
  end
end
