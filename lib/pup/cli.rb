module Pup
  require 'thor'

  class Cli < Thor
    default_task :start

    desc 'start', 'start the pup webserver'
    option :port, type: :numeric, default: 8000
    def start
      Pup::Server.new(options[:port])
    end
  end
end
