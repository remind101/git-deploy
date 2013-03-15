require 'spec_helper'
require 'git-deploy/middleware/heroku_workers'

describe Git::Deploy::Middleware::HerokuWorkers, :middleware => true, :sh => true do

  subject { described_class.new app }

  it { should be_a( Git::Deploy::Middleware ) }

  it 'performs the correct steps in order' do
    step subject, :sh,  'heroku', 'ps'
    step subject, :sh,  'heroku', 'ps:scale worker=0'
    step app,     :call, env
    step subject, :sh,  'heroku', 'ps:scale worker=1'

    subject.call env
  end
  it 'returns env' do
    subject.call( env ).should == env
  end
end
