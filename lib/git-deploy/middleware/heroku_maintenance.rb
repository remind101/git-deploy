class Git::Deploy::Middleware::HerokuMaintenance
  include Git::Deploy::Middleware

  def call( env )
    remote, refspec = env

    if remote.heroku?
      # TODO need to specify the remote or app here
      sh 'heroku', 'maintenance:on', :remote => 'staging'
    end

    env = app.call [ remote, refspec ]

    if remote.heroku?
      sh 'heroku', 'maintenance:off', :remote => 'staging'
    end

    env
  rescue Interrupt => e
    if remote.heroku?
      sh 'heroku', 'maintenance:off', :remote => 'staging'
    end

    raise
  end
end
