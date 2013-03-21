require 'shellwords'

module Git
  module Deploy
    module Utils
      class Remote

        def initialize( env )
          @options, @remote, @branch, @args = env
        end

        def push
          `git push #{[ @remote, @branch, *@args ].shelljoin}`
        end
      end
    end
  end
end
