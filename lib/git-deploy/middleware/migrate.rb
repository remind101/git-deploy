class Git::Deploy::Middleware::Migrate
  include Git::Deploy::Middleware

  ##
  # Runs pending migrations if the migrate option was given.
  def call( env )
    remote, refspec = app.call env

    if remote.heroku? && options.migrate?
      `heroku run rake db:migrate --remote #{remote}`
    end

    [ remote, refspec ]
  end
end
