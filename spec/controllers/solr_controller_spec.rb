require 'spec_helper'

describe SolrController do

  describe "GET 'core'" do
    it "returns http success" do
      get 'core'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'copy_schema'" do
    it "returns http success" do
      get 'copy_schema'
      response.should be_success
    end
  end

end
