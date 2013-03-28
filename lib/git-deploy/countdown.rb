class Git::Deploy::Countdown

  def self.used( opts )
    opts.on :c, :countdown, 'Count down before deploying.'
  end

  def initialize( app )
    @app = app
  end

  ##
  # Asks the user to confirm the deployment before proceeding.
  def call( env )

    if env[ 'options.countdown' ]

      print "Deploying in t minus "
      5.downto( 1 ) do |n|
        print "#{n}..."
        sleep 1
      end
      puts
    end

    @app.call env
  end
end
