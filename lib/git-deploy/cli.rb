require 'thor'

module Git
  module Deploy
    class CLI < Thor

      ##
      # Defines a new thor command for deployment to the specified remote.
      def self.define_remote_command( remote )

        # Describe the command
        desc "#{remote} [<refspec>]", "Deploy <refspec> to #{remote}"
        # Add the --confirm option
        method_option :confirm,
          :type => :boolean,
          :desc => 'Prompt the user to confirm the deploy'
        # Define the method
        define_method remote do |refspec='HEAD'|
          if options.confirm? && !yes?( "Really deploy #{refspec} to #{remote}?" )
            raise Git::Deploy::Interrupt
          end
          runner.deploy remote, refspec
        end
      end


      ##
      #
      # TODO this needs to be in an instance method. Is there a generic
      # handler for thor commands.
      # trap( 'INT' ){ runner.interrupt! }

      ##
      #
      def runner
        @runner ||= Git::Deploy::Runner.new
      end

    end
  end
end
