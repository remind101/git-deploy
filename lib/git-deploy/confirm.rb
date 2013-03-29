class Git::Deploy::Confirm

  def self.configure( opts )
    opts.on :c, :confirm, 'Ask the user to confirm the deployment.'
  end

  def initialize( app )
    @app = app
  end

  ##
  # Asks the user to confirm the deployment before proceeding.
  def call( env )

    if env[ 'options.confirm' ] && !confirm?( env[ 'remote' ], env[ 'branch' ] )
      raise Interrupt, 'Use cancelled the deployment.'
    end

    @app.call env
  end

  def confirm?( remote, branch )
    shell = HighLine.new
    shell.ask? "Deploy #{branch} to #{remote}?"
  end
end
