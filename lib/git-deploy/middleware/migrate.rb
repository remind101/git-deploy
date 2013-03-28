class Git::Deploy::Middleware::Migrate

  def self.used( opts )
    opts.on :m, :migrate, 'Run migrations after deployment.'
  end

  def initialize( app )
    @app = app
  end

  ##
  # Runs pending migrations if the migrate option was given.
  def call( env )

    @app.call env

    if env[ 'options.migrate' ] && env[ 'remote.heroku' ]
      # TODO catch exit status
      `heroku run rake db:migrate --remote #{env[ 'remote' ]}`
    end

    env
  end
end
