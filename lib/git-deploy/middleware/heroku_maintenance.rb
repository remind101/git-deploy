class Git::Deploy::Middleware::HerokuMaintenance
  include Git::Deploy::Middleware

  def call( env )
    # TODO need to specify the remote or app here
    sh 'heroku', 'maintenance:on --remote staging'
    env = app.call env
    sh 'heroku', 'maintenance:off --remote staging'
    env
  end
end
