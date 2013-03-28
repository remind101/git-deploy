require 'net/http'

class Git::Deploy::Hipchat

  def initialize( app, config )
    @app, @config = app, config
  end

  def call( env )
    hipchat "#{user} is deploying #{env[ 'branch' ]} to #{env[ 'remote' ]}",
      :color => 'yellow'

    @app.call env

    hipchat "#{user} successfully deployed #{env[ 'branch' ]} to #{env[ 'remote' ]}",
      :color => 'green'

  rescue Interrupt => e
    hipchat "#{user} interrupted the deploy of #{env[ 'branch' ]} to #{env[ 'remote' ]}",
      :color => 'red'

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
