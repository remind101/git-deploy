class Git::Deploy::Middleware::Migrate
  include Git::Deploy::Middleware

  ##
  # Runs pending migrations if the migrate option was given.
  def call( env )
    remote, refspec = env

    if options.migrate?
      sh 'heroku', 'run', 'rake' 'db:migrate', :remote => remote.name
    end

    app.call env
  end
end
