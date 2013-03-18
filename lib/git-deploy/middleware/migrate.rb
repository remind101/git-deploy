class Git::Deploy::Middleware::Migrate
  include Git::Deploy::Middleware

  ##
  # Runs pending migrations if the migrate option was given.
  def call( env )
    remote, refspec = app.call env

    if remote.heroku? && options.migrate?
      sh 'heroku', 'run', 'rake' 'db:migrate', :remote => remote.name
    end

    [ remote, refspec ]
  end
end
