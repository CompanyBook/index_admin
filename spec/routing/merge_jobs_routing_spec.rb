require "spec_helper"

describe MergeJobsController do
  describe "routing" do

    it "routes to #index" do
      get("/merge_jobs").should route_to("merge_jobs#index")
    end

    it "routes to #new" do
      get("/merge_jobs/new").should route_to("merge_jobs#new")
    end

    it "routes to #show" do
      get("/merge_jobs/1").should route_to("merge_jobs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/merge_jobs/1/edit").should route_to("merge_jobs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/merge_jobs").should route_to("merge_jobs#create")
    end

    it "routes to #update" do
      put("/merge_jobs/1").should route_to("merge_jobs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/merge_jobs/1").should route_to("merge_jobs#destroy", :id => "1")
    end

  end
end
