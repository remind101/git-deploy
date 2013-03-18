require 'spec_helper'
require 'git-deploy/middleware/heroku_workers'

describe Git::Deploy::Middleware::HerokuWorkers, :middleware => true do

  subject { described_class.new app }

  it { should be_a( Git::Deploy::Middleware ) }

  it 'performs the correct steps in order' do
    step subject, :`,   'heroku ps --remote staging'
    step subject, :`,   'heroku ps:scale worker\=0 --remote staging'
    step app,     :call, env
    step subject, :`,   'heroku ps:scale worker\=1 --remote staging'

    subject.call env
  end
  it 'returns env' do
    subject.call( env ).should == env
  end
end
