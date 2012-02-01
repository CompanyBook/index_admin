require 'spec_helper'

describe "merge_jobs/new.html.erb" do
  before(:each) do
    assign(:merge_job, stub_model(MergeJob,
      :hdfs_src => "MyString",
      :dest_server => "MyString",
      :dest_path => "MyString"
    ).as_new_record)
  end

  it "renders new merge_job form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => merge_jobs_path, :method => "post" do
      assert_select "input#merge_job_hdfs_src", :name => "merge_job[hdfs_src]"
      assert_select "input#merge_job_dest_server", :name => "merge_job[dest_server]"
      assert_select "input#merge_job_dest_path", :name => "merge_job[dest_path]"
    end
  end
end
