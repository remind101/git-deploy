require 'spec_helper'
require 'git-deploy/middleware/heroku_maintenance'

describe Git::Deploy::Middleware::HerokuMaintenance, :middleware => true do

  it { should be_a( Git::Deploy::Middleware ) }

  it 'performs the correct steps in order' do
    step subject, :`,   'heroku maintenance:on --remote staging'
    step app,     :call, env
    step subject, :`,   'heroku maintenance:off --remote staging'

    subject.call env
  end
  it 'returns env' do
    subject.call( env ).should == env
  end
end
