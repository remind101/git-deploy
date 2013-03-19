class Git::Deploy::Middleware::Migrate
  include Git::Deploy::Middleware

  option :migrate, :type => :boolean, :default => false,
    :desc => 'Run migrations after deployment'

  ##
  # Runs pending migrations if the migrate option was given.
  def call( env )
    remote, branch = app.call env

    if remote.heroku? && options.migrate?
      `heroku run rake db:migrate --remote #{remote}`
    end

    [ remote, branch ]
  end
end
