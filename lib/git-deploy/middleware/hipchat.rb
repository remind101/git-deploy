class Git::Deploy::Middleware::Hipchat
  include Git::Deploy::Middleware

  def call( env )
    remote, refspec = env

    sh 'hipchat', "say '[FILTERED]' --color yellow #{hipchat_flags}"

    env = app.call env

    sh 'hipchat', "say '[FILTERED]' --color yellow #{hipchat_flags}"

    env
  end

  def hipchat_flags
    {
      '--auth-token' => '[FILTERED]',
      '--room-id'    => 'Developers',
      '--from'       => 'Deploy'
    }.to_a.join ' '
  end
end
