require 'active_support/log_subscriber'
require 'active_support/notifications'
require 'securerandom'
require 'yell'

module Git
  module Deploy
    class LogSubscriber < ActiveSupport::LogSubscriber

      ##
      #
      def plugin( event )
        debug '%s (%.1fms)' % [
          color( event.payload[ :plugin ], YELLOW ), event.duration ]
      end

      ##
      # Configure a new logger for, erm, logging?
      self.logger = Yell.new do |l|
        l.level = ENV[ 'LOG_LEVEL' ] ||= 'info'
        l.adapter STDOUT, :level => [ :debug, :info, :warn ]
        l.adapter STDERR, :level => [ :error, :fatal ]
      end
    end
  end
end
