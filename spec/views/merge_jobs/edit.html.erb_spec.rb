require 'spec_helper'

describe "merge_jobs/edit.html.erb" do
  before(:each) do
    @merge_job = assign(:merge_job, stub_model(MergeJob,
      :hdfs_src => "MyString",
      :dest_server => "MyString",
      :dest_path => "MyString"
    ))
  end

  it "renders the edit merge_job form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => merge_jobs_path(@merge_job), :method => "post" do
      assert_select "input#merge_job_hdfs_src", :name => "merge_job[hdfs_src]"
      assert_select "input#merge_job_dest_server", :name => "merge_job[dest_server]"
      assert_select "input#merge_job_dest_path", :name => "merge_job[dest_path]"
    end
  end
end
