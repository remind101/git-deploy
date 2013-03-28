require 'net/http'

class Git::Deploy::Hipchat

  def initialize( app, config )
    @app, @config = app, config
  end

  def call( env )

    unless env[ 'deploy.hipchat.auth_token' ]
      raise ArgumentError, <<-EOS
      #{self.class} requires that `deploy.hipchat.auth_token` be set in
      your git config. Add the config by with the following command
      or remove this middleware from the stack in .gitdeploy.

        git config add deploy.hipchat.auth_token [your value]
      EOS
    end

    hipchat "#{user} is deploying #{env[ 'branch' ]} to #{env[ 'remote' ]}",
      :color => 'yellow', :auth_token => env[ 'deploy.hipchat.auth_token' ]

    @app.call env

    hipchat "#{user} successfully deployed #{env[ 'branch' ]} to #{env[ 'remote' ]}",
      :color => 'green', :auth_token => env[ 'deploy.hipchat.auth_token' ]

  rescue Interrupt => e
    hipchat "#{user} interrupted the deploy of #{env[ 'branch' ]} to #{env[ 'remote' ]}",
      :color => 'red', :auth_token => env[ 'deploy.hipchat.auth_token' ]

    raise
  end

  def user
    `git config user.email`.chomp
  end

  def hipchat( message, options={} )
    options.merge! @config
    options.merge! :message => message

    uri  = URI 'https://api.hipchat.com/v1/rooms/message'

    req  = Net::HTTP::Post.new uri.path
    req.set_form_data options

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true

    http.request req
  end
end
