class Git::Deploy::Middleware::HerokuWorkers

  def initialize( app )
    @app = app
  end

  def call( env )

    if env[ 'remote.heroku' ]
      # TODO catch exit status
      @workers = `heroku ps --remote #{env[ 'remote' ]} | grep -c worker`.to_i
    end

    if env[ 'remote.heroku' ] && @workers
      # TODO catch exit status
      `heroku ps:scale worker=0 --remote #{env[ 'remote' ]}`
    end

    @app.call env

    if env[ 'remote.heroku' ] && @workers
      # TODO catch exit status
      `heroku ps:scale worker=#{@workers} --remote #{env[ 'remote' ]}`
    end

    env
  rescue Interrupt
    if env[ 'remote.heroku' ] && @workers
      # TODO catch exit status
      `heroku ps:scale worker=#{@workers} --remote #{env[ 'remote' ]}`
    end


    raise
  end
end
