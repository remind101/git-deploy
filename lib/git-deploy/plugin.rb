require 'active_support/callbacks'
require 'active_support/notifications'

module Git
  module Deploy
    class Plugin
      include ActiveSupport::Callbacks

      define_callbacks :deploy

      class << self

        ##
        # Sugar syntax for setting a before deploy callback.
        def before( &block )
          set_callback :deploy, :before, &block
        end

        ##
        # Sugar syntax for setting an after deploy callback.
        def after( &block )
          set_callback :deploy, :after, &block
        end

        ##
        # Sugar syntax for setting an around deploy callback.
        def around( &block )
          set_callback :deploy, :around, &block
        end
      end

      ##
      # Instrument all plugin callbacks.
      around do |&block|
        ActiveSupport::Notifications.instrument \
          'plugin.deploy', { :plugin => self.class.to_s }, &block
      end

      ##
      # Subscribe to plugin notifications
      Git::Deploy::LogSubscriber.attach_to 'deploy'
    end
  end
end
