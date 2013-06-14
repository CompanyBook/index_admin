require 'logger'

module Logging
  def log
    Logging.log.progname = self.class
    Logging.log
  end

  def self.log
    @logger ||= add_formatting(create)
  end

  def self.add_formatting(log)
    log.formatter = proc do |severity, datetime, progname, msg|
      "%s %-5s %s - %s\r\n" % [datetime.strftime('%F %H:%M:%S'), severity, progname, msg]
    end
    log
  end

  def self.create
    Logger.new('logfile.log', 10, 1000*1000)
  end
end