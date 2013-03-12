class Git::Deploy::Plugins::Status < Git::Deploy::Plugin

  before do
    say 'Deploying %s to %s' % [ env.ref, env.remote ]
  end

  after do
    say 'Deployed successfully!'
  end

  trap 'TERM' do
    say 'Deploy terminated.'
  end
end
