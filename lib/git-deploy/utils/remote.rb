module Git
  module Deploy
    module Utils
      class Remote

        def initialize( env )
          @options, @remote, @branch, @args = env
        end

        def heroku?
          `git config remote.#{@remote}.url` =~ /^git@heroku\.com:/
        end
      end
    end
  end
end
