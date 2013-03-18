class Git::Deploy::Middleware::HerokuWorkers
  include Git::Deploy::Middleware

  def call( env )
    remote, refspec = env

    if remote.heroku?
      @workers = sh( 'heroku', 'ps', :remote => 'staging' ).lines.grep( /^worker\./ ).count
    end

    if remote.heroku?
      sh 'heroku', 'ps:scale', 'worker=0', :remote => 'staging'
    end

    env = app.call env

    if remote.heroku? && @workers
      sh 'heroku', 'ps:scale', "worker=#{@workers}", :remote => 'staging'
    end

    env

  rescue Interrupt => e
    if remote.heroku? && @workers
      sh 'heroku', 'ps:scale', "worker=#{@workers}", :remote => 'staging'
    end

    raise
  end
end
