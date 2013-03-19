class Git::Deploy::Middleware::HerokuBranch
  include Git::Deploy::Middleware

  ##
  # If this remote is a heroku app, sets the destination branch to "master".
  def call( env )
    remote, branch = env

    if remote.heroku? && !branch.name.end_with?( 'master' )
      branch.name = "#{branch.name}:master"
    end

    app.call [ remote, branch ]
  end
end
