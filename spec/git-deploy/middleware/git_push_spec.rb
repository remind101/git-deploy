require 'spec_helper'
require 'git-deploy/middleware/git_push'

describe Git::Deploy::Middleware::GitPush, :middleware => true do

  it { should be_a( Git::Deploy::Middleware ) }

  before { options.stub :force? => false }

  it 'performs the correct steps in order' do
    step subject, :`,   'git push staging develop'
    step app,     :call, env

    subject.call env
  end
  it 'returns env' do
    subject.call( env ).should == env
  end
end
