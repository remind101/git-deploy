class Git::Deploy::Middleware::Confirm
  include Git::Deploy::Middleware

  option :confirm, :type => :boolean, :default => false,
    :desc => 'Ask the user to confirm the deployment'

  ##
  # Asks the user to confirm the deployment before proceeding.
  def call( env )
    remote, refspec = env

    if options.confirm? && !yes?( "Deploy #{refspec} to #{remote}?" )
      raise Thor::Error, 'User cancelled the deployment.'
    end

    app.call env
  end
end
