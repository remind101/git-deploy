require 'spec_helper'
require 'git-deploy/middleware/git_push'

describe Git::Deploy::Middleware::GitPush, :middleware => true do

  it { should be_a( Git::Deploy::Middleware ) }

  before( :force => true  ){ options.stub :force? => true  }
  before( :force => false ){ options.stub :force? => false }

  it 'performs the correct steps in order', :force => false do
    step subject, :`,   'git push staging develop'
    step app,     :call, env

    subject.call env
  end
  it 'performs the correct steps in order when forced', :force => true do
    step subject, :`,   'git push staging develop --force'
    step app,     :call, env

    subject.call env
  end
  it 'returns env', :force => false do
    subject.call( env ).should == env
  end
end
