class Git::Deploy::Middleware::Hipchat
  include Git::Deploy::Middleware

  def call( env )
    remote, refspec = env

    sh 'hipchat', 'say', "Deploying #{refspec.name} to #{remote.name}",
      :color => 'yellow'

    env = app.call env

    sh 'hipchat', 'say', "Successfully deployed #{refspec.name} to #{remote.name}",
      :color => 'green'

    env

  rescue Interrupt => e
    sh 'hipchat', 'say', 'Deployment interrupted',
      :color => 'red'

    raise
  end
end
