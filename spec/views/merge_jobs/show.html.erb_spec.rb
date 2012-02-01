require 'spec_helper'

describe "merge_jobs/show.html.erb" do
  before(:each) do
    @merge_job = assign(:merge_job, stub_model(MergeJob,
      :hdfs_src => "Hdfs Src",
      :dest_server => "Dest Server",
      :dest_path => "Dest Path"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Hdfs Src/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Dest Server/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Dest Path/)
  end
end
