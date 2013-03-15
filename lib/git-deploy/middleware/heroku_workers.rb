class Git::Deploy::Middleware::HerokuWorkers
  include Git::Deploy::Middleware

  def call( env )
    # TODO only if remote.heroku?
    @workers = sh( 'heroku', 'ps' ).lines.grep( /^worker\./ ).count

    sh 'heroku', 'ps:scale worker=0'

    env = app.call env

    sh 'heroku', "ps:scale worker=#{@workers}"

    env
  end
end
