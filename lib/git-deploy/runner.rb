require 'active_support/callbacks'

module Git
  module Deploy
    class Runner
      include ActiveSupport::Callbacks

      define_callbacks :deploy

      def deploy( remote, refname )
        run_callbacks :deploy do
          Git[ 'push', remote, refspec, '--dry-run' ]
        end
      end

    end
  end
end
