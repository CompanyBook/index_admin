require 'net/ssh'
require_relative '../../lib/remote_server'
require_relative '../log_to_stdout'

describe RemoteServer do
  it "should get available space", :ignore => true do
    puts RemoteServer.new.available_space_as_map
  end

  it "should get solr indexes from hdsf" do
    puts RemoteServer.new.hdfs_solr_index_paths
  end

  it "should get tree space", :ignore => true do
    puts RemoteServer.new.solr_index_locations.print_as_tree
  end

  it "should find job_id", :ignore => true do
    puts RemoteServer.new.find_job_id('/user/hjellum/solrindex/dk_companies_20120123')
  end

  it "should run solr index copy and merge local", :ignore => true do
    args = {simulate: true,
            hadoop_src: '/solrindex/se_companies_20120123',
            copy_dst: '/data/c/solr/companies/se_companies_20120123',
            max_merge_size: '150G',
            dst_distribution: ['/data/f/copy_to/se_companies_20120123']}

    puts RemoteServer.new('localhost', 'Rune', '~/Source/hdfs_copy_solr_index').
             run_solr_index_copy_and_merge(args)
  end

  it "should run solr index copy and merge on server datanode29", :ignore => true do
    args = {simulate: true,
            hadoop_src: '/solrindex/se_companies_20120123',
            copy_dst: '/data/c/solr/companies/se_companies_20120123',
            max_merge_size: '150G',
            dst_distribution: ['/data/f/copy_to/se_companies_20120123']}

    puts RemoteServer.new('datanode29.companybook.no', 'hjellum', '~/hdfs_copy_solr_index').
             run_solr_index_copy_and_merge(args)
  end

  it "should find job_solr_schema " do
    puts RemoteServer.new().find_job_solr_schema('/user/ssavenko/solrindex/dk_companies_20131227_solr4')
  end

  it 'should find home dir' do
    p RemoteServer.new.find_user_home_dir('/user/ssavenko/solrindex/dk_companies_20131227_solr4')
  end

  it "should check_solr_installation", :ignore => true do
    puts RemoteServer.new.check_solr_installation('/usr/local/solr/apache-solr-3.5.0/example/webapps/WEB-INF/lib', '3.5.0')
  end

  it "should find job_id mocking run_and_return_lines" do
    server = RemoteServer.new
    server.stub(:run_and_return_lines).and_return ['hdfs://namenode.companybook.no/user/hjellum/solrindex/dk_companies_20120123/_logs/history/jobtracker.companybook.no_1322087824719_job_201111232237_4396_conf.xml']
    server.find_job_id('').should == 'job_201111232237_4396'
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