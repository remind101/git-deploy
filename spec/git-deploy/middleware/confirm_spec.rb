require 'spec_helper'
require 'git-deploy/middleware/confirm'

describe Git::Deploy::Middleware::Confirm, :middleware => true do

  it { should be_a( Git::Deploy::Middleware ) }

  before( :confirm => true  ){ options.stub :confirm? => true  }
  before( :confirm => false ){ options.stub :confirm? => false }
  before( :yes => true      ){ subject.shell.stub :yes? => true  }
  before( :yes => false     ){ subject.shell.stub :yes? => false }

  it 'asks the user to confirm when confirm is true', :confirm => true, :yes => true do
    step subject, :yes?, 'Deploy develop to staging?'
    step app,     :call,  env

    subject.call env
  end
  it 'raises an exception when the user answers no', :confirm => true, :yes => false do
    expect { subject.call( env ) }.to raise_error( Thor::Error )
  end
  it 'returns env', :confirm => false do
    subject.call( env ).should == env
  end
end
