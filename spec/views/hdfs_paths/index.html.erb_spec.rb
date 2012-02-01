require 'spec_helper'

describe "hdfs_paths/index.html.erb" do
  before(:each) do
    assign(:hdfs_paths, [
      stub_model(HdfsPath,
        :path => "Path"
      ),
      stub_model(HdfsPath,
        :path => "Path"
      )
    ])
  end

  it "renders a list of hdfs_paths" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Path".to_s, :count => 2
  end
end
