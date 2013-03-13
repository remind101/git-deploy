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
          # TODO we obviously don't want to push to master if this is
          # not a heroku app. Fix this to be more generic in the future?
          # Or maybe make this more like a middleware chain
          # and create a heroku middleware that always pushes to master?
          Git[ 'push', remote, "#{refspec}:master", '--dry-run' ]
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
        @env ||= Env.new :remote => remote, :refspec => refspec
      end

      ##
      # Instrument all deploy runs.
      set_callback :deploy, :before do
        ActiveSupport::Notifications.instrument \
          'before.deploy', { :env => env }
      end
    end
  end
end

# TODO move this elsewhere
# TODO make this look at a `.gitdeploy` file?
Git::Deploy::Runner.instance_eval <<-RUBY
  require 'git-deploy/plugins/status'
  require 'git-deploy/plugins/hipchat_status'
  require 'git-deploy/plugins/heroku_workers'
  require 'git-deploy/plugins/heroku_maintenance'


  use Git::Deploy::Plugins::Status
  # use Git::Deploy::Plugins::HipChatStatus
  use Git::Deploy::Plugins::HerokuWorkers
  use Git::Deploy::Plugins::HerokuMaintenance
RUBY
