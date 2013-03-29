class Git::Deploy::HerokuMaintenance

  def self.configure( opts )
    opts.on :d, :maintenance, 'Turn on maintenance mode during deployment'
  end

  def initialize( app )
    @app = app
  end

  def call( env )

    if env[ 'options.maintenance' ] && env[ 'remote.heroku' ]
      # TODO catch exit status
      `heroku maintenance:on --remote #{env[ 'remote' ]}`
    end

    @app.call env

    if env[ 'options.maintenance' ] && env[ 'remote.heroku' ]
      # TODO catch exit status
      `heroku maintenance:off --remote #{env[ 'remote' ]}`
    end

    env
  rescue Interrupt
    if env[ 'options.maintenance' ] && env[ 'remote.heroku' ]
      # TODO catch exit status
      `heroku maintenance:off --remote #{env[ 'remote' ]}`
    end


    raise
  end
end
