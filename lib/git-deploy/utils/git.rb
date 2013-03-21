module Git
  module Deploy
    module Utils
      class Git

        def initialize( env ) # :nodoc:
          @options, @remote, @branch, *@args = env
        end

        ##
        # Pushes `@branch` to `@remote`.
        def push
          Shell[ "git push #{@remote} #{@branch} #{@args.join ' '}" ]
        end

        ##
        # Finds the branch the git repository is currently on.
        def current_branch
          File.basename Shell[ 'git symbolic-ref HEAD' ]
        end

        ##
        # Finds the remote associated with the current branch.
        def current_remote
          Shell[ "git config deploy.#{current_branch}.remote" ]
        end

        ##
        # Whether or not there is a current remote.
        def current_remote?
          !current_remote.empty?
        end
      end
    end
  end
end
