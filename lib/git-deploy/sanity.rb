class Git::Deploy::Sanity

  def initialize( app )
    @app = app
  end

  def call( env )

    env[ 'remote' ] ||= current_remote

    unless remote_exists? env[ 'remote' ]
      raise ArgumentError, "Remote '#{env[ 'remote' ]}' does not exist"
    end

    env[ 'branch' ] ||= current_branch

    unless branch_exists? env[ 'branch' ]
      raise ArgumentError, "Branch '#{env[ 'branch' ]}' does not exist"
    end

    @app.call env
  end

  def current_branch
    `basename $(git symbolic-ref HEAD)`
  end

  def branch_exists?( branch )
    system %Q{test -n "$(git branch --list #{branch})"}
  end

  def current_remote
    `git config deploy.#{current_branch}.remote`
  end

  def remote_exists?( remote )
    system "git remote | grep #{remote} -qx"
  end
end
