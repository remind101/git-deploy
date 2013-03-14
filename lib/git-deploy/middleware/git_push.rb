class Git::Deploy::Middleware::GitPush
  include Git::Deploy::Middleware

  def call( env )
    puts '==> [git push] before call'

    remote, refspec = env

    command.run :remote => remote.name, :refspec => refspec.name

    @app.call [ remote, object ]
  end

  def command
    # TODO --force?
    Cocaine::CommandLine.new 'git', 'push :remote :refspec --dry-run'
  end
end
