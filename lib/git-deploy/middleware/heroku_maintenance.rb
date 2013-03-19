class Git::Deploy::Middleware::HerokuMaintenance
  include Git::Deploy::Middleware

  def call( env )
    remote, branch = env

    if remote.heroku?
      `heroku maintenance:on --remote #{remote}`
    end

    env = app.call [ remote, branch ]

    if remote.heroku?
      `heroku maintenance:off --remote #{remote}`
    end

    env
  rescue Interrupt => e
    if remote.heroku?
      `heroku maintenance:off --remote #{remote}`
    end

    raise
  end
end
