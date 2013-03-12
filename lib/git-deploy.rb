require 'git-deploy/version'

module Git
  module Deploy
    # autoload :CLI, 'git-deploy/cli'

    class << self

      def remotes
        `git remote`.lines.map &:chomp
      end

      def deploy( remote, refspec )
        puts 'DEPLOY'
        puts remote.inspect
        puts refspec.inspect
      end
    end
  end
end
