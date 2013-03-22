class Git::Deploy::Middleware::HerokuMaintenance

  def self.used( opts )
    opts.on :d, :maintenance, 'Turn on maintenance mode during deployment'
  end

  def initialize( app )
    @app = app
  end

  def call( env )
    options, _ = env

    remote = Git::Deploy::Utils::Remote.new env
    heroku = Git::Deploy::Utils::Heroku.new env

    heroku.maintenance_on if options.maintenance? && remote.heroku?

    env = @app.call env

    heroku.maintenance_off if options.maintenance? && remote.heroku?

    env
  rescue Interrupt
    heroku.maintenance_off if options.maintenance? && remote.heroku?

    raise
  end
end
