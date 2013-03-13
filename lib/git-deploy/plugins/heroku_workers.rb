require 'heroku-api'

class Git::Deploy::Plugins::HerokuWorkers < Git::Deploy::Plugin



  before :if => :heroku_app? do
    @workers = heroku.get_ps( env.app )
    require 'pry'
    binding.pry
    # say t( 'workers.current', :count =>  )
  end
  # before :if => :heroku_app? do
  #   client.post_app_maintenance env.app, '1'
  #   say t( 'maintenance.enabled' ), :yellow
  # end
  #
  # after :if => :heroku_app? do
  #   client.post_app_maintenance env.app, '0'
  #   say t( 'maintenance.disabled' ), :green
  # end
  #
  # interrupt :if => :heroku_app? do
  #   client.post_app_maintenance env.app, '0'
  #   say t( 'maintenance.disabled' ), :green
  # end

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
