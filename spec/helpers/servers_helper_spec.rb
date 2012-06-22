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

  it "should find all solr serves contains a core name" do
    admin1 = SolrCoreAdmin.new('solr_name1', 'solr_port1', 1)
    admin1.stub(:servers).and_return [
                                         {"name"=>"core_1"},
                                         {"name"=>"core_2"}
                                     ]
    admin2 = SolrCoreAdmin.new('solr_name2', 'solr_port2', 2)
    admin2.stub(:servers).and_return [
                                         {"name"=>"core_3"},
                                         {"name"=>"core_2"}
                                     ]
    @solr_core_admins = [admin1, admin2]

    get_solr_server('core_2').collect {|s| s.name }.should == ['solr_name1', 'solr_name2']
  end

  it "should find if core is live" do
    admin1 = SolrCoreAdmin.new('solr_name1', 'solr_port1', 1)
    admin1.stub(:servers).and_return [
                                         {"name"=>"core_1"},
                                         {"name"=>"core_2"}
                                     ]
    admin2 = SolrCoreAdmin.new('solr_name2', 'solr_port2', 2)
    admin2.stub(:servers).and_return [
                                         {"name"=>"core_3"},
                                         {"name"=>"core_2"}
                                     ]
    @solr_core_admins = [admin1, admin2]

    p live_solr_core?('core_2')
  end
end
