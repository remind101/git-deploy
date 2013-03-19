require 'spec_helper'
require 'git-deploy/middleware/sanity'

describe Git::Deploy::Middleware::Sanity, :middleware => true do

  it { should be_a( Git::Deploy::Middleware ) }

  it 'raises an exception when the remote is left blank' do
    remote.stub :name => nil
    expect { subject.call( env ) }.to raise_error( Thor::Error )
  end
  it 'raises an exception when the remote does not exist' do
    remote.stub :exists? => false
    expect { subject.call( env ) }.to raise_error( Thor::Error )
  end
  it 'returns env' do
    remote.stub :exists? => true
    subject.call( env ).should == env
  end
end
