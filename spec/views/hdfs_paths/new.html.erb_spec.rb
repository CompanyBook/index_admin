require 'spec_helper'

describe "hdfs_paths/new.html.erb" do
  before(:each) do
    assign(:hdfs_path, stub_model(HdfsPath,
      :path => "MyString"
    ).as_new_record)
  end

  it "renders new hdfs_path form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hdfs_paths_path, :method => "post" do
      assert_select "input#hdfs_path_path", :name => "hdfs_path[path]"
    end
  end
end
