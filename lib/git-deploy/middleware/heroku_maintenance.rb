class Git::Deploy::Middleware::HerokuMaintenance
  include Git::Deploy::Middleware

  def call( env )
    # TODO only if remote.heroku?
    # TODO need to specify the remote or app here
    sh 'heroku', 'maintenance:on', :remote => 'staging'

    env = app.call env

    sh 'heroku', 'maintenance:off', :remote => 'staging'

    env
  rescue Interrupt => e
    sh 'heroku', 'maintenance:off', :remote => 'staging'
    raise
  end
end
