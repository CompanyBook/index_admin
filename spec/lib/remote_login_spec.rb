require_relative '../../lib/remote_server'

describe RemoteServer do
  it "should get available space", :ignore => true do
    puts RemoteServer.new.available_space_as_map
  end

  it "should get solr indexes from hdsf", :ignore => true do
    puts RemoteServer.new.hdfs_solr_index_paths
  end

  it "should get tree space", :ignore => true do
    puts RemoteServer.new.solr_index_locations.print_as_tree
  end

  it "should run solr index copy and merge", :ignore => true do
    puts RemoteServer.new('local').run_solr_index_copy_and_merge('/solrindex/se_companies_20120123', '/data/c/solr/companies/se_companies_20120123', '/data/f/copy_to/se_companies_20120123')
  end

  it "should get name from path" do
    test = RemoteServer::FileTree.new('/data/c/solr/companies/no_companies_20120123')
    test.name.should == 'no_companies_20120123'
  end

  it "should get create tree from paths" do
    paths = [
        '/data/a',
        '/data/a/1',
        '/data/a/2',
        '/data/a/2/11',
        '/data/a/2/12',
        '/data/b',
        '/data/b/1',
    ]

    root = RemoteServer::FileTree.new('/data')
    paths.each do |path|
      root.add(path)
    end

    root.to_s.should == '/data - [/data/a - [/data/a/1 - [], /data/a/2 - [/data/a/2/11 - [], /data/a/2/12 - []]], /data/b - [/data/b/1 - []]]'
  end

  it "should add node" do
    root = RemoteServer::FileTree.new('/data')
    root.add('/data/a')
    root.to_s.should == '/data - [/data/a - []]'
    root.add('/data/a/1')
    root.to_s.should == '/data - [/data/a - [/data/a/1 - []]]'
    root.add('/data/a/1/11')
    root.to_s.should == '/data - [/data/a - [/data/a/1 - [/data/a/1/11 - []]]]'
  end

  it "should find parent node from root" do
    root = RemoteServer::FileTree.new('/data')
    root.add('/data/a')
    root.find('/data/a/1').to_s.should == '/data/a - []'
  end

  it "should get nice output", :ignore => true do
    paths = [
        '10G /data/a',
        '50G /data/b',
        '20G /data/b/solr',
        '30G /data/b/solr/companies',
        '40G /data/b/solr/companies/no_companies_20121217'].collect { |line| line.split /\s+/ }

    root = RemoteServer::FileTree.new('/data', '10G')
    paths.each do |size, path|
      root.add(path, size)
    end

    puts root.print_as_tree
  end

end