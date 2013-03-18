class Git::Deploy::Middleware::Confirm
  include Git::Deploy::Middleware

  ##
  # Asks the user to confirm the deployment before proceeding.
  def call( env )
    remote, refspec = env

    if options.confirm? && !shell.yes?( "Deploy #{refspec} to #{remote}?" )
      raise Thor::Error, 'User cancelled the deployment.'
    end

    app.call env
  end
end
