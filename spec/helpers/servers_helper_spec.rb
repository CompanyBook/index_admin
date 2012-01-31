require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ServersHelper. For example:
#
# describe ServersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ServersHelper do
  it "should be below solr" do
    root = RemoteServer::FileTree.new('solr')
    c1 = root.add('solr/1')
    is_below_solr?(c1).should == true
  end

  it "should be not below solr" do
    root = RemoteServer::FileTree.new('a')
    c1 = root.add('a/1')
    is_below_solr?(c1).should == false
  end
end
