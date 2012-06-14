module ServersHelper
  def header_for(file_info)
    file_info.size + (file_info.avail_space.present? ? '/' + file_info.avail_space : '')
  end

  def is_solr_index?(file_info)
    file_info.children.find { |dir| dir.name == 'conf' || dir.name == 'data' }
  end

  def is_below_solr?(file_info)
    found = file_info
    while(found.parent)
      return true if found.parent.name.start_with?('solr')
      found = found.parent
    end
    false
  end
end
