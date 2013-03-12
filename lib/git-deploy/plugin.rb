require 'active_support/callbacks'

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
    end
  end
end
