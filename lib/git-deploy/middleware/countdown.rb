class Git::Deploy::Middleware::Countdown

  def self.used( opts )
    opts.on :c, :countdown, 'Count down before deploying.'
  end

  def initialize( app )
    @app = app
  end

  ##
  # Asks the user to confirm the deployment before proceeding.
  def call( env )
    options, remote, branch = env

    countdown if options.countdown?

    @app.call env
  end

  def countdown
    print "Deploying in t minus "
    5.downto(1) do |n|
      print "#{n}..."
      sleep 1
    end
    puts
  end
end
