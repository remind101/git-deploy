class Git::Deploy::Middleware::HerokuMaintenance

  def initialize( app )
    @app = app
  end

  def call( env )

    options, remote, branch, *args = env

    if heroku?( remote )
      Git::Deploy::Utils::Heroku.new( remote ).maintenance_on
    end

    env = @app.call env

    if heroku?( remote )
      Git::Deploy::Utils::Heroku.new( remote ).maintenance_off
    end

    env
  rescue Interrupt => e
    if heroku?( remote )
      Git::Deploy::Utils::Heroku.new( remote ).maintenance_off
    end

    raise
  end

  def heroku?( remote )
    `git config remote.#{remote}.url` =~ /^git@heroku\.com:/
  end
end
