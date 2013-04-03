class Git::Deploy::Sanity

  def initialize( app )
    @app = app
  end

  def call( env )

    env[ 'branch' ] ||= env[ 'git.branch' ]

    unless branch_exists? env[ 'branch' ]
      raise ArgumentError, "Branch '#{env[ 'branch' ]}' does not exist"
    end

    env[ 'remote' ] ||= env[ 'git.remote' ]

    unless remote_exists? env[ 'remote' ]
      raise ArgumentError, "Remote '#{env[ 'remote' ]}' does not exist"
    end

    @app.call env
  end

  def branch_exists?( branch )
    system "git show-ref --quiet --verify refs/heads/#{branch}"
  end

  def remote_exists?( remote )
    system "git-show-ref --quiet --verify refs/heads/#{remote}/master"
  end
end
