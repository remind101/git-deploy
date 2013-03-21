class Git::Deploy::Middleware::Migrate

  def self.used( opts )
    opts.on :m, :migrate, 'Run migrations after deployment'
  end

  def initialize( app )
    @app = app
  end

  ##
  # Runs pending migrations if the migrate option was given.
  def call( env )

    options, _ = @app.call env

    remote = Git::Deploy::Utils::Remote.new env
    heroku = Git::Deploy::Utils::Heroku.new env

    heroku.run( 'rake db:migrate' ) if options.migrate? && remote.heroku?

    env
  end
end
