require 'thor'

module Git
  module Deploy
    class CLI < Thor

      ##
      # Set up a deploy command for each git remote.
      Git::GIT.remotes.map(&:name).each do |remote|
        class_eval <<-RUBY

        ##
        # Deploy <refspec> to #{remote}. Will deploy <HEAD> if no refspec
        # is given.
        desc '#{remote} [<refspec>]', 'Deploy <refspec> to #{remote}'
        def #{remote}( refspec='HEAD' )
          Git::Deploy.deploy '#{remote}', refspec
        end
        RUBY
      end

    end
  end
end
