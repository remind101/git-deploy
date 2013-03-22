require 'net/http'

class Git::Deploy::Middleware::Librato

  def initialize( app, config )
    @app, @config = app, config
  end

  ##
  # Reports deployment to librato.
  def call( env )
    options, remote, branch = env
    librato( remote, branch ) do
      @app.call env
    end
  end

  # "Deploy $revision ($sha)"
  # "$user deployed $branch to $remote"
  def librato( remote, branch )
    start_time = Time.now.to_i
    yield
    end_time   = Time.now.to_i

    params = {
      title: "Deploy #{branch}"
      description: "#{user} deployed #{branch} to #{remote}"
      source: @config[:source]
      start_time: start_time,
      end_time: end_time
    }
    uri  = URI 'https://metrics-api.librato.com/v1/annotations/deploy'

    req  = Net::HTTP::Post.new uri.path
    req.set_form_data params
    req.basic_auth @config[:user], @config[:password]

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true

    http.request req
  end

  def user
    `git config user.email`.chomp
  end

end
