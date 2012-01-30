require "spec_helper"

describe HdfsPathsController do
  describe "routing" do

    it "routes to #index" do
      get("/hdfs_paths").should route_to("hdfs_paths#index")
    end

    it "routes to #new" do
      get("/hdfs_paths/new").should route_to("hdfs_paths#new")
    end

    it "routes to #show" do
      get("/hdfs_paths/1").should route_to("hdfs_paths#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hdfs_paths/1/edit").should route_to("hdfs_paths#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hdfs_paths").should route_to("hdfs_paths#create")
    end

    it "routes to #update" do
      put("/hdfs_paths/1").should route_to("hdfs_paths#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hdfs_paths/1").should route_to("hdfs_paths#destroy", :id => "1")
    end

  end
end
