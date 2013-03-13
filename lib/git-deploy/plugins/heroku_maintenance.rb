require 'heroku-api'

class Git::Deploy::Plugins::HerokuMaintenance < Git::Deploy::Plugin

  before :if => :heroku_app? do
    client.post_app_maintenance env.app, '1'
    say t( 'maintenance.on' ), :yellow
  end

  after :if => :heroku_app? do
    client.post_app_maintenance env.app, '0'
    say t( 'maintenance.off' ), :green
  end

  interrupt :if => :heroku_app? do
    client.post_app_maintenance env.app, '0'
    say t( 'maintenance.off' ), :green
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
