require 'net/http'

class Git::Deploy::Hipchat

  def initialize( app, config )
    @app, @config = app, config
  end

  def call( env )
    @env = env

    unless authtoken
      raise ArgumentError, <<-EOS
      #{self.class} requires that `hipchat.authtoken` be set in
      your git config. Add the config by with the following command
      or remove this middleware from the stack in .gitdeploy.

        git config --add hipchat.authtoken [your value]
      EOS
    end

    hipchat messages[:deploying] % [ email, thing, remote ], :color => 'yellow'

    @app.call env

    hipchat messages[:deployed] % [ email, thing, remote ], :color => 'green'

  rescue Interrupt => e
    hipchat messages[:interrupt] % [ email, thing, remote ], :color => 'red'

    raise
  end

  def hipchat( message, options={} )
    options.merge! @config
    options.merge! :message => message, :authtoken => authtoken

    uri  = URI 'https://api.hipchat.com/v1/rooms/message'

    req  = Net::HTTP::Post.new uri.path
    req.set_form_data options

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true

    http.request req
  end

private
  attr_reader :env

  def authtoken
    env[ 'git.config.hipchat.authtoken' ]
  end

  def thing
    heroku? ? "#{app}##{branch}" : branch
  end

  def email
    env[ 'git.config.user.email' ]
  end

  def branch
    env[ 'branch' ]
  end

  def remote
    env[ 'remote' ]
  end

  def app
    env[ 'remote.app' ]
  end

  def heroku?
    env[ 'remote.heroku' ]
  end

  def messages
    {
      :deploying => "%s is deploying %s to %s",
      :deployed  => "%s successfully deployed %s to %s",
      :interrupt => "%s interrupted the deploy of %s to %s"
    }
  end

end
