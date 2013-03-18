require 'thor'
require 'git'

module Git
  module Deploy
    class CLI < Thor

      ##
      # Create a new git client.
      GIT = Git.open Dir.pwd

      ##
      # Define a new thor command for deploying to each remote.
      GIT.remotes.each do |remote|

        desc "#{remote} [<refspec>]", "Deploy <refspec> to #{remote}"

        # TODO there should be some way to make the middlewares
        # themselves install these options.
        method_option :confirm, :type => :boolean, :default => false,
          :desc => 'Ask the user to confirm the deployment'

        method_option :migrate, :type => :boolean, :default => false,
          :desc => 'Run pending migrations as part of the deployment'

        # TODO a --no-hipchat option

        define_method remote.name do |refspec='HEAD'|
          runner.call [ remote, GIT.object( refspec ) ]
        end
      end

      ##
      # Prints the current middleware stack.
      desc 'stack', 'Prints the current middleware stack'
      def stack
        print_table runner.stack
      end

      no_tasks do

        ##
        # The deploy middleware runner instance.
        def runner
          @runner ||= Git::Deploy::Runner.new options
        end
      end

    end
  end
end
