class Git::Deploy::Plugins::Status < Git::Deploy::Plugin

  before do
    say t( 'deploy.initiated' ), :yellow
  end

  after do
    say t( 'deploy.finished' ), :green
  end

  interrupt do
    say t( 'deploy.interrupted' ), :red
  end
end
