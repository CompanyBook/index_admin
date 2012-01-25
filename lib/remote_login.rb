require 'net/ssh'

class RemoteLogin
  def initialize(server='datanode29.companybook.no', name='hjellum')
    @server = server
    @user = name
  end

  def run(cmd)
    stdout = ""
    Net::SSH.start(@server, @name) do |ssh|
      ssh.exec!(cmd) do |channel, stream, data|
        stdout << data #if stream == :stdout
      end
    end
    stdout
  end


  def go
    puts 'loging in...'
    Net::SSH.start('datanode29.companybook.no', 'hjellum') do |ssh|
      # capture all stderr and stdout output from a remote process
      output = ssh.exec!("datanode29.companybook.no")

      stdout = ""
      #ssh.exec!("ls -l /home/hjellum") do |channel, stream, data|
      ssh.exec!("df -h") do |channel, stream, data|
        stdout << data #if stream == :stdout
      end
      puts stdout
    end
  end

  ServerHdSpaceInfo = Struct.new( :size, :used, :avail, :location )

  def available_space
    result = run('df  | grep /data/ | awk \'{print $2" "$3" "$4" "$6 }\'')
    result.split("\n").collect { |a| ServerHdSpaceInfo.new(*a.split(/\s+/)) }
  end

  def show_tree(name)
    '' '
-- a
|-- b
|   |-- lost+found
|   `-- solr
|       `-- companies
|           `-- no_companies_20121217
|-- c
|   |-- lost+found
|   `-- solr
|       `-- companies
|           |-- dk
|           |-- no_companies_20120117
|           |-- no_companies_20120123
|           |-- se_companies_20120116
|           `-- se_companies_20120123
|-- d
|   |-- lost+found
|   `-- solr
|       `-- companies
|           |-- dk_companies_20120113
|           |-- dk_companies_20120116
|           |-- dk_companies_20120123
|           |-- gb_companies_20120116
|           `-- gb_companies_20120123
|-- e
|   |-- lost+found
|   `-- solr
|       `-- companies
|           |-- global_20120116
|           |-- global_20120117
|           |-- global_20120123
|           `-- global_20120124
`-- f
    |-- copy_to
    |   `-- solrindex
    |       |-- dk_companies_20120123
    |       |-- gb_companies_20120123
    |       |-- global_20120117
    |       |-- global_20120123
    |       |-- global_20120124
    |       |-- no_companies_20120117
    |       |-- no_companies_20120123
    |       `-- se_companies_20120123
    `-- lost+found
' ''
  end
end
