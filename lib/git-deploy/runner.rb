require 'active_support/callbacks'

module Git
  module Deploy
    class Runner
      include ActiveSupport::Callbacks

      define_callbacks :deploy

      ##
      # Adds a plugin to the plugin stack.
      def self.use( plugin )
        set_callback :deploy, :around do |&block|
          plugin.new.run_callbacks :deploy, &block
        end
      end

      ##
      # Runs the deploy plugins around a push to the specified remote.
      def deploy( remote, refspec )
        run_callbacks :deploy do
          Git[ 'push', remote, refspec, '--dry-run' ]
        end
      end
    end
  end
end

# TODO move this elsewhere
# TODO make this look at a `.gitdeploy` file?
Git::Deploy::Runner.instance_eval <<-RUBY
  require 'git-deploy/plugins/status'

  use Git::Deploy::Plugins::Status
RUBY
