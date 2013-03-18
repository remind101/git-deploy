class Git::Deploy::Middleware::Hipchat
  include Git::Deploy::Middleware

  def call( env )
    remote, refspec = env

    sh 'hipchat', 'say', 'Deploying develop to staging',
      :color => 'yellow'

    env = app.call env

    sh 'hipchat', 'say', 'Successfully deployed develop to staging',
      :color => 'green'

    env

  rescue Interrupt => e
    sh 'hipchat', 'say', 'Deployment interrupted',
      :color => 'red'
    raise
  end
end
