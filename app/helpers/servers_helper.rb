module ServersHelper
  def header_for(file_info)
    file_info.size + (file_info.avail_space.present? ? '/' + file_info.avail_space : '')
  end
end
