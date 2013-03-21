require 'net/http'

class Git::Deploy::Middleware::Hipchat

  def initialize( app, config )
    @app, @config = app, config
  end

  def call( env )

    options, remote, branch, *args = env

    hipchat "#{user} is deploying #{branch} to #{remote}",
      :color => 'yellow'

    env = @app.call env

    hipchat "#{user} successfully deployed #{branch} to #{remote}",
      :color => 'green'

    env
  rescue Interrupt => e
    hipchat "#{user} interrupted the deploy of #{branch} to #{remote}",
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
