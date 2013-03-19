class Git::Deploy::Middleware::HerokuBranch
  include Git::Deploy::Middleware

  ##
  # If this remote is a heroku app, sets the destination branch to "master".
  def call( env )
    remote, branch = env

    if remote.heroku? && !branch.full.end_with?( 'master' )
      branch.full = "#{branch}:master"
    end

    app.call [ remote, branch ]
  end
end
