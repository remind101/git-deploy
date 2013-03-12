require 'hipchat'

class Git::Deploy::Plugins::HipChatStatus < Git::Deploy::Plugin

  before do
    client[ 'Developers' ].send 'Deploy',
      '%s initiated deployment of %s to %s' % [ env.user, env.branch, env.remote ],
      :notify => true, :color => 'yellow'
  end

  interrupt do
    client[ 'Developers' ].send 'Deploy',
      '%s interrupted the deployment' % [ env.user ],
      :notify => true, :color => 'red'
  end


  # TODO look at other message formatting options, like HTML
  # https://github.com/hipchat/hipchat-rb
  # https://www.hipchat.com/docs/api/method/rooms/message
  def client
    @client ||= HipChat::Client.new ENV[ 'HIPCHAT_AUTH_TOKEN' ]
  end
end
