require 'spec_helper'
require 'git-deploy/middleware/git_push'

describe Git::Deploy::Middleware::GitPush, :middleware => true do

  subject { described_class.new app }

  it { should be_a( Git::Deploy::Middleware ) }

  it 'performs the correct steps in order' do
    step subject, :sh,   'git', 'push origin develop --dry-run'
    step app,     :call, env

    subject.call env
  end
  it 'returns env' do
    subject.call( env ).should == env
  end
end
