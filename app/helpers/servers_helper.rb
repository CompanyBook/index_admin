require 'solr_core_admin'

module ServersHelper

  def header_for(file_info)
    file_info.size + (file_info.avail_space.present? ? '/' + file_info.avail_space : '')
  end

  def is_solr_index?(file_info)
    file_info.children.find { |dir| dir.name == 'conf' || dir.name == 'data' }
  end

  def is_below_solr?(file_info)
    found = file_info
    while (found.parent)
      return true if found.parent.name.start_with?('solr')
      found = found.parent
    end
    false
  end

  def solr_core_admins
    @solr_core_admins ||= @selected_solr_instances.collect { |solr| SolrCoreAdmin.new(solr.name, solr.port) }
  end

  def solr_cores
    @solr_cores ||= solr_core_admins.collect { |s| s.servers }.flatten
  end

  def is_solr_server(name)
    solr_cores.find { |item| puts "key - #{item}" ; item['name']==name }
  end

  def solr_class(name)
    if( is_solr_server(name) )
      return 'solr_mounted'
    end
    ''
  end
end
