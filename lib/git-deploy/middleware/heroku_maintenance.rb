class Git::Deploy::Middleware::HerokuMaintenance

  def initialize( app )
    @app = app
  end

  def call( env )

    remote = Git::Deploy::Utils::Remote.new env
    heroku = Git::Deploy::Utils::Heroku.new env

    heroku.maintenance_on if remote.heroku?

    env = @app.call env

    heroku.maintenance_off if remote.heroku?

    env
  rescue Interrupt
    heroku.maintenance_off if remote.heroku?

    raise
  end
end
