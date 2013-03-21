module Git
  module Deploy
    module Utils
      class Remote

        def initialize( env ) # :nodoc:
          @options, @remote, @branch, *@args = env
        end

        ##
        # Whether or not the url for the remote is on heroku.
        def heroku?
          Shell[ "git config remote.#{@remote}.url" ] =~ /^git@heroku\.com:/
        end
      end
    end
  end
end
