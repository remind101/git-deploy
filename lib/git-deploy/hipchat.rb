require 'net/http'

class Git::Deploy::Hipchat

  def initialize( app, config )
    @app, @config = app, config
  end

  def call( env )

    unless env[ 'hipchat.authtoken' ]
      raise ArgumentError, <<-EOS
      #{self.class} requires that `hipchat.authtoken` be set in
      your git config. Add the config by with the following command
      or remove this middleware from the stack in .gitdeploy.

        git config --add hipchat.authtoken [your value]
      EOS
    end

    hipchat "#{user} is deploying #{env[ 'branch' ]} to #{env[ 'remote' ]}",
      :color => 'yellow', :auth_token => env[ 'hipchat.authtoken' ]

    @app.call env

    hipchat "#{user} successfully deployed #{env[ 'branch' ]} to #{env[ 'remote' ]}",
      :color => 'green', :auth_token => env[ 'hipchat.authtoken' ]

  rescue Interrupt => e
    hipchat "#{user} interrupted the deploy of #{env[ 'branch' ]} to #{env[ 'remote' ]}",
      :color => 'red', :auth_token => env[ 'hipchat.authtoken' ]

    raise
  end

  def user
    @user ||= `git config user.email`.chomp
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
