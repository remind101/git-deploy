require 'active_support/callbacks'

module Git
  module Deploy
    class Runner
      include ActiveSupport::Callbacks

      define_callbacks :deploy, :interrupt

      ##
      # Adds a plugin to the plugin stack.
      def self.use( plugin_class )
        # Forward deploy callbacks to the plugin instance.
        set_callback :deploy, :around do |&block|
          plugins[ plugin_class ].run_callbacks :deploy, &block
        end
        # Forward interrupt callbacks to the plugin instance.
        set_callback :interrupt, :around do |&block|
          plugins[ plugin_class ].run_callbacks :interrupt, &block
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
        trap( 'INT' ){ run_callbacks( :interrupt ){ exit 1 } }

        run_callbacks :deploy do
          puts 'SLEEPING'
          sleep 10
          puts 'AWAKE AGAIN'
          # Git[ 'push', remote, refspec, '--dry-run' ]
        end
      end

      ##
      # A managed hash of all plugin instances by class.
      # Because singletons are for chumps.
      def plugins
        @plugins ||= Hash.new { |h, k| h[ k ] = k.new( env ) }
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
  # use Git::Deploy::Plugins::HipChatStatus
RUBY
