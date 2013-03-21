class Git::Deploy::Middleware::Migrate

  def self.used( opts )
    opts.on :m, :migrate, 'Run migrations after deployment'
  end

  def initialize( app )
    @app = app
  end

  ##
  # Runs pending migrations if the migrate option was given.
  def call( env )

    options, remote, branch, *args = @app.call env

    if options.migrate? && heroku?( remote )
      Git::Deploy::Heroku.new( remote ).run 'rake db:migrate'
    end

    env
  end

  def heroku?( remote )
    `git config remote.#{remote}.url` =~ /^git@heroku\.com:/
  end
end
