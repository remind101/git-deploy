class Git::Deploy::GitBranch

  def initialize( app )
    @app = app
  end

  def call( env )

    env[ 'branch' ] ||= current_branch

    unless branch_exists? env[ 'branch' ]
      raise ArgumentError, "Branch '#{env[ 'branch' ]}' does not exist"
    end

    @app.call env
  end

  def current_branch
    `git symbolic-ref --short HEAD`.chomp!
  end

  def branch_exists?( branch )
    system "git show-ref --quiet --verify refs/heads/#{branch}"
  end
end
