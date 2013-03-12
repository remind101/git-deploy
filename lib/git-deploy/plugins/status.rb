class Git::Deploy::Plugins::Status < Git::Deploy::Plugin

  before do
    puts 'Deploying %s to %s' % [ env.branch, env.remote ]
  end

  after do
    puts 'Deployed successfully!'
  end

  # trap 'INT' do
  #   puts 'Deploy interrupted.'
  #   exit 1
  # end
end
