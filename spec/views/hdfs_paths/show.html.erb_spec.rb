require 'spec_helper'

describe "hdfs_paths/show.html.erb" do
  before(:each) do
    @hdfs_path = assign(:hdfs_path, stub_model(HdfsPath,
      :path => "Path"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Path/)
  end
end
