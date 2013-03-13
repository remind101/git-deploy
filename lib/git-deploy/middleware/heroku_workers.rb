require 'heroku-api'

class Git::Deploy::Plugins::HerokuWorkers < Git::Deploy::Plugin

  before :if => :heroku_app? do
    @workers = client.get_app( env.app ).body[ 'workers' ]
    say t( 'workers.current', :count => @workers )
  end

  before :if => :heroku_app? do
    client.post_ps_scale env.app, 'worker', 0
    say t( 'workers.scaling', :count => 0 ), :yellow
  end

  after :if => :heroku_app? do
    client.post_ps_scale env.app, 'worker', @workers
    say t( 'workers.scaling', :count => @workers ), :green
  end

  interrupt :if => :heroku_app? do
    client.post_ps_scale env.app, 'worker', @workers
    say t( 'workers.scaling', :count => @workers ), :green
  end

  ##
  # Is this a heroku app?
  def heroku_app?
    env.app != nil
  end

  ##
  # A heroku api client. Expects HEROKU_API_KEY to be set in ENV.
  def client
    @client ||= Heroku::API.new
  end
end
