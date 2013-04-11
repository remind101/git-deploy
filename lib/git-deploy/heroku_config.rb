class Git::Deploy::HerokuConfig

  def initialize( app )
    @app = app
  end

  def call( env )

    # TODO i want to write env[ 'remote.url' ] here, like this should
    # be normalized for me by now.
    url = env[ "git.config.remote.#{env[ 'remote' ]}.url" ]
    env[ 'remote.heroku' ] = url.start_with? 'git@heroku.com:'

    @app.call env
  end
end
