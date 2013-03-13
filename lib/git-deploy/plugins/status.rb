class Git::Deploy::Plugins::Status < Git::Deploy::Plugin

  before do
    say t( 'deploy.initiated', env.to_hash ), :yellow
  end

  after do
    say t( 'deploy.finished', env.to_hash ), :green
  end

  interrupt do
    say t( 'deploy.interrupted', env.to_hash ), :red
  end
end
