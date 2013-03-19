require 'spec_helper'
require 'git-deploy/middleware/migrate'

describe Git::Deploy::Middleware::Migrate, :middleware => true do

  it { should be_a( Git::Deploy::Middleware ) }

  before( :migrate => true  ){ options.stub :migrate? => true  }
  before( :migrate => false ){ options.stub :migrate? => false }

  it 'does not run migrations by default', :heroku => true, :migrate => true do
    step app, :call, env

    subject.call env
  end
  it 'runs migrations on heroku', :heroku => true, :migrate => true do
    step app,     :call, env
    step subject, :`,   'heroku run rake db:migrate --remote staging'

    subject.call env
  end
  it 'returns env' do
    subject.call( env ).should == env
  end
end
