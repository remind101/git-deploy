class Git::Deploy::Middleware::HerokuMaintenance
  include Git::Deploy::Middleware

  def call( env )
    # TODO need to specify the remote or app here
    sh 'heroku', 'maintenance:on'
    env = app.call env
    sh 'heroku', 'maintenance:off'
    env
  end
end
