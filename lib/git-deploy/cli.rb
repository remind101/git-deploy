require 'thor'

module Git
  module Deploy
    class CLI < Thor

      Git::Deploy.git.remotes.each do |remote|

        ##
        # Defines a new thor command for deployment to the specified remote.
        desc "#{remote} [<refspec>]", "Deploy <refspec> to #{remote}"

        method_option :confirm, :type => :boolean, :default => false

        define_method remote.name do |refspec='HEAD'|
          runner.call [ remote, git.object( refspec ) ]
        end
      end

      ##
      # Prints the current middleware stack.
      desc 'stack', 'Prints the current middleware stack'
      def stack
        print_table runner.send( :stack )
      end

      no_tasks do

        ##
        # The deploy middleware runner instance.
        def runner
          @runner ||= Git::Deploy::Runner.new options
        end

        ##
        # The shared git instance.
        def git
          Git::Deploy.git
        end
      end

    end
  end
end
