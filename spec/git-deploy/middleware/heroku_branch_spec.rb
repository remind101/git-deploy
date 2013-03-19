require 'spec_helper'
require 'git-deploy/middleware/heroku_branch'

describe Git::Deploy::Middleware::HerokuBranch, :middleware => true do

  it { should be_a( Git::Deploy::Middleware ) }

  it 'does not alter the destination branch', :heroku => false do
    branch.should_not_receive( :full= )
    subject.call( env )
  end
  it 'sets the destination branch to `master`', :heroku => true do
    branch.should_receive( :full= ).with( 'develop:master' )
    subject.call( env )
  end
  it 'returns env' do
    subject.call( env ).should == env
  end
end
