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
          plugin.new( env ).run_callbacks :deploy, &block
        end
      end

      ##
      #
      def initialize( remote, refspec )
        @remote, @refspec = remote, refspec
      end
      attr_reader :remote, :refspec

      ##
      # Runs the deploy plugins around a push to the specified remote.
      def run!
        run_callbacks :deploy do
          Git[ 'push', remote, refspec, '--dry-run' ]
        end
      end

      ##
      # The current git repo env.
      def env
        @env ||= Env.new remote, refspec
      end
    end
  end
end

# TODO move this elsewhere
# TODO make this look at a `.gitdeploy` file?
Git::Deploy::Runner.instance_eval <<-RUBY
  require 'git-deploy/plugins/status'
  require 'git-deploy/plugins/hipchat_status'

  use Git::Deploy::Plugins::Status
  use Git::Deploy::Plugins::HipChatStatus
RUBY
