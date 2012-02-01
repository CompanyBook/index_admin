require 'spec_helper'

describe "merge_jobs/index.html.erb" do
  before(:each) do
    assign(:merge_jobs, [
      stub_model(MergeJob,
        :hdfs_src => "Hdfs Src",
        :dest_server => "Dest Server",
        :dest_path => "Dest Path"
      ),
      stub_model(MergeJob,
        :hdfs_src => "Hdfs Src",
        :dest_server => "Dest Server",
        :dest_path => "Dest Path"
      )
    ])
  end

  it "renders a list of merge_jobs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Hdfs Src".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Dest Server".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Dest Path".to_s, :count => 2
  end
end
