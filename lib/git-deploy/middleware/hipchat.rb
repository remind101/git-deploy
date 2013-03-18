class Git::Deploy::Middleware::Hipchat
  include Git::Deploy::Middleware

  def call( env )
    remote, refspec = env

    `hipchat say '#{user} is deploying #{refspec} to #{remote}' --color yellow`

    env = app.call env

    `hipchat say '#{user} successfully deployed #{refspec} to #{remote}' --color green`

    env
  rescue Interrupt => e
    `hipchat say '#{user} interrupted the deploy' --color red`

    raise
  end
end
