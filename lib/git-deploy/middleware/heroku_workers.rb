class Git::Deploy::Middleware::HerokuWorkers
  include Git::Deploy::Middleware

  def call( env )
    # TODO only if remote.heroku?
    @workers = sh( 'heroku', 'ps', :remote => 'staging' ).lines.grep( /^worker\./ ).count

    sh 'heroku', 'ps:scale', 'worker=0', :remote => 'staging'

    env = app.call env

    sh 'heroku', 'ps:scale', "worker=#{@workers}", :remote => 'staging'

    env

  rescue Interrupt => e
    sh 'heroku', 'ps:scale', "worker=#{@workers}", :remote => 'staging'

    raise
  end
end
