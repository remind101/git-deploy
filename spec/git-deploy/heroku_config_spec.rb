require 'spec_helper'

describe Git::Deploy::HerokuConfig, :middleware => true do

  subject { described_class.new app }

  it 'sets remote.heroku to true if the remote url looks like heroku' do
    env[ 'remote' ] = 'production'
    env[ 'git.config.remote.production.url' ] = 'git@heroku.com:app.git'

    subject.call env

    env[ 'remote.heroku' ].should == true
  end
  it 'sets remote.heroku to false if the remote url looks like something else' do
    env[ 'remote' ] = 'production'
    env[ 'git.config.remote.production.url' ] = 'git@github.com:app.git'

    subject.call env

    env[ 'remote.heroku' ].should == false
  end
  it 'sets remote.heroku.app to the app slug if the remote url looks like heroku' do
    env[ 'remote' ] = 'production'
    env[ 'git.config.remote.production.url' ] = 'git@heroku.com:app.git'

    subject.call env

    env[ 'remote.app' ].should == 'app'
  end
end
