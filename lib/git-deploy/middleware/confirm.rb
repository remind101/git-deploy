class Git::Deploy::Middleware::Confirm

  def self.used( opts )
    opts.on :c, :confirm, 'Ask the user to confirm the deployment.'
  end

  def initialize( app )
    @app = app
  end

  ##
  # Asks the user to confirm the deployment before proceeding.
  def call( env )

    options, remote, branch = env

    shell = Git::Deploy::Utils::Shell.new

    if options.confirm? && !shell.agree( "Deploy #{branch} to #{remote}?" )
      raise Interrupt, 'Use cancelled the deployment.'
    end

    @app.call env
  end
end
