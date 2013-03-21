require 'shellwords'

module Git
  module Deploy
    module Utils
      class Git

        def initialize( env )
          @options, @remote, @branch, @args = env
        end

        def push
          `git push #{[ @remote, @branch, *@args ].shelljoin}`
        end

        def current_remote
          remote = `git config deploy.#{current_branch}.remote`.chomp
          remote.empty? ? nil : remote
        end

        def current_branch
          File.basename `git symbolic-ref HEAD`.chomp
        end
      end
    end
  end
end
