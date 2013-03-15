require 'hipchat'

class Git::Deploy::Middleware::HipChatStatus
  include Git::Deploy::Middleware

  def call( env )

    puts 'HIPCHAT!!!'
    require 'pry'
    binding.pry
    # initiated: '%{user} initiated deployment of %{branch} (%{sha}) to %{remote}'
    # finished: '%{user} finished deployment of %{branch} (%{sha}) to %{remote}'
    remote, refspec = env

    hipchat '%s initiated deployment of %s (%s) to %s' % [ git.config[ 'user.email' ], refspec.name, refspec.sha ]

    app.call [ remote, refspec ]

    # puts '==> [hipchat status] after call'

    [ remote, refspec ]
  end

  # before do
  #   hipchat 'deploy.initiated', :notify => true, :color => 'yellow'
  # end
  #
  # after do
  #   hipchat 'deploy.finished', :notify => true, :color => 'green'
  # end
  #
  # interrupt do
  #   hipchat 'deploy.interrupted', :notify => true, :color => 'red'
  # end

  ##
  # Send a message to the developers hipchat room.
  def hipchat( msg, options={} )
    client[ 'Developers' ].send 'Deploy', t( msg ), options
  end

  # TODO look at other message formatting options, like HTML
  # https://github.com/hipchat/hipchat-rb
  # https://www.hipchat.com/docs/api/method/rooms/message
  def client
    @client ||= HipChat::Client.new ENV[ 'HIPCHAT_AUTH_TOKEN' ]
  end
end
