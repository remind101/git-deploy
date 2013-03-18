class Git::Deploy::Middleware::Hipchat
  include Git::Deploy::Middleware

  def call( env )
    remote, refspec = env

    sh 'hipchat', 'say', 'Deploying develop to staging',
      hipchat_flags.merge( :color => 'yellow' )

    env = app.call env

    sh 'hipchat', 'say', 'Successfully deployed develop to staging',
      hipchat_flags.merge( :color => 'green' )

    env
  end

  def hipchat_flags
    {
      :auth_token => '000000000000000000000000000000',
      :room_id    => 'Developers',
      :from       => 'Deploy'
    }
  end
end
