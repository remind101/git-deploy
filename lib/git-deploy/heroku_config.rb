class Git::Deploy::HerokuConfig

  def initialize( app )
    @app = app
  end

  def call( env )

    # TODO i want to write env[ 'remote.url' ] here, like this should
    # be normalized for me by now.
    @url = env[ "git.config.remote.#{env[ 'remote' ]}.url" ]

    env[ 'remote.heroku' ]   = heroku?
    env[ 'remote.app'    ] ||= app if heroku?

    @app.call env
  end

private
  attr_reader :url

  def heroku?
    url.start_with? 'git@heroku.com:'
  end

  def app
    url.gsub /.*@.*:(.*)\.git/, '\1'
  end

end
