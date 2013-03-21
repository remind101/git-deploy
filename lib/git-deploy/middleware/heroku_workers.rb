class Git::Deploy::Middleware::HerokuWorkers

  def initialize( app )
    @app = app
  end

  def call( env )

    remote = Git::Deploy::Utils::Remote.new env
    heroku = Git::Deploy::Utils::Heroku.new env

    # FIXME this should be heroku.ps[ :worker ].count
    @workers = heroku.ps[ :worker ] if remote.heroku?

    heroku.ps_scale( :worker => 0 ) if remote.heroku? && @workers

    env = @app.call env

    heroku.ps_scale( :worker => @workers ) if remote.heroku? && @workers

    env
  rescue Interrupt
    heroku.ps_scale( :worker => @workers ) if remote.heroku? && @workers

    raise
  end
end
