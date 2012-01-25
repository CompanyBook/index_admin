#require 'spec_helper'
require_relative '../../lib/remote_login'

describe RemoteLogin do
  it "should do login" do
    puts RemoteLogin.new('datanode29.companybook.no', 'hjellum').available_space
  end
end