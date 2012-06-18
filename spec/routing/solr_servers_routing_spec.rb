require "spec_helper"

describe SolrServersController do
  describe "routing" do

    it "routes to #index" do
      get("/solr_servers").should route_to("solr_servers#index")
    end

    it "routes to #new" do
      get("/solr_servers/new").should route_to("solr_servers#new")
    end

    it "routes to #show" do
      get("/solr_servers/1").should route_to("solr_servers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/solr_servers/1/edit").should route_to("solr_servers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/solr_servers").should route_to("solr_servers#create")
    end

    it "routes to #update" do
      put("/solr_servers/1").should route_to("solr_servers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/solr_servers/1").should route_to("solr_servers#destroy", :id => "1")
    end

  end
end
