require 'thor'

module Git
  module Deploy
    class CLI < Thor

      # TODO default_task :push

      ##
      # Run the current middleware stack around a push.
      desc 'push [<repository> [<refspec>...]]', 'Run the current middleware stack around a push'
      def push( remote=git.current_remote, branch=git.current_branch )
        runner.call [ git.remote( remote ), git.object( branch ) ]
      end

      # print_table git.targets.map { |branch, remote|
      #   [ ('*' if branch.current), branch, '=>', remote, remote.url ]
      # }

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

        def git
          Git::Deploy.git
        end
      end
    end
  end
end
