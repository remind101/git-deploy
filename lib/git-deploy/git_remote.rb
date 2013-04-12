class Git::Deploy::GitRemote

  def initialize( app )
    @app = app
  end

  def call( env )

    env[ 'remote' ] ||= begin
      env[ "git.config.branch.#{env[ 'branch' ]}.remote" ] or raise( ArgumentError, <<-EOS )
      There is no remote associated with branch '#{env[ 'branch' ]}'.
      Either specify the remote or set one up with the following command:

        git branch -u [REMOTE]/master #{env[ 'branch' ]}
      EOS
    end

    unless remote_exists? env[ 'remote' ]
      raise ArgumentError, "Remote '#{env[ 'remote' ]}' does not exist"
    end

    @app.call env
  end

  def remote_exists?( remote )
    system "git show-ref --quiet --verify refs/remotes/#{remote}/master"
  end
end
