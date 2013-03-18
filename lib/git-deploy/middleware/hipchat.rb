class Git::Deploy::Middleware::Hipchat
  include Git::Deploy::Middleware

  def call( env )
    remote, refspec = env

    sh 'hipchat', 'say', "#{user} is deploying #{refspec.name} to #{remote.name}",
      :color => 'yellow'

    env = app.call env

    sh 'hipchat', 'say', "#{user} successfully deployed #{refspec.name} to #{remote.name}",
      :color => 'green'

    env

  rescue Interrupt => e
    sh 'hipchat', 'say', "#{user} interrupted the deploy",
      :color => 'red'

    raise
  end

  def user
    `git config user.email`.chomp
  end
end
