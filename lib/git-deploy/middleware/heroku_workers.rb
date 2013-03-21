class Git::Deploy::Middleware::HerokuWorkers

  def initialize( app )
    @app = app
  end

  def call( env )

    options, remote, branch, *args = env

    if heroku?( remote )
      @workers = Git::Deploy::Utils::Heroku.new( remote ).ps[ :worker ]
    end

    if heroku?( remote )
      Git::Deploy::Utils::Heroku.new( remote ).ps_scale :worker => 0
    end

    env = @app.call env

    if heroku?( remote ) && @workers
      Git::Deploy::Utils::Heroku.new( remote ).ps_scale :worker => @workers
    end

    env
  rescue Interrupt => e
    if heroku?( remote ) && @workers
      Git::Deploy::Utils::Heroku.new( remote ).ps_scale :worker => @workers
    end

    raise
  end

  def heroku?( remote )
    `git config remote.#{remote}.url` =~ /^git@heroku\.com:/
  end
end
