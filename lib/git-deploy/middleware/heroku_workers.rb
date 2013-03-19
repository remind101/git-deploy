class Git::Deploy::Middleware::HerokuWorkers
  include Git::Deploy::Middleware

  def call( env )
    remote, branch = env

    if remote.heroku?
      @workers = `heroku ps --remote #{remote}`.lines.grep( /^worker\./ ).count
    end

    if remote.heroku?
      `heroku ps:scale worker=0 --remote #{remote}`
    end

    env = app.call env

    if remote.heroku? && @workers
      `heroku ps:scale worker=#{@workers} --remote #{remote}`
    end

    env
  rescue Interrupt => e
    if remote.heroku? && @workers
      `heroku ps:scale worker=#{@workers} --remote #{remote}`
    end

    raise
  end
end
