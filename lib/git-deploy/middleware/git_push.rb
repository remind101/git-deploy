class Git::Deploy::Middleware::GitPush

  def initialize( app )
    @app = app
  end
  attr_reader :app

  def call( env )
    puts '==> [git push] before call'

    remote, object = @app.call( env )

    puts '==> [git push] after call'

    [ remote, object ]
  end
end
