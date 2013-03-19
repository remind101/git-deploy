class Git::Deploy::Middleware::Hipchat
  include Git::Deploy::Middleware

  def call( env )
    remote, refspec = env

    `hipchat --message '#{user} is deploying #{refspec} to #{remote}' --color yellow`

    env = app.call env

    `hipchat --message '#{user} successfully deployed #{refspec} to #{remote}' --color green`

    env
  rescue Interrupt => e
    `hipchat --message '#{user} interrupted the deploy' --color red`

    raise
  end
end
