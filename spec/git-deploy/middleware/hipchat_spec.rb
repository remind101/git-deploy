require 'spec_helper'
require 'git-deploy/middleware/hipchat'

describe Git::Deploy::Middleware::Hipchat, :middleware => true do

  subject { described_class.new app, { } }

  it 'performs the correct steps in order' do
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com is deploying master to production', :color => 'yellow' ).ordered
        app.should_receive( :call ).with( env )
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com successfully deployed master to production', :color => 'green' ).ordered

    subject.call env
  end
  it 'handles an interrupt' do
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com is deploying master to production', :color => 'yellow' ).ordered
        app.should_receive( :call ).with( env ).and_raise( Interrupt )
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com interrupted the deploy of master to production', :color => 'red' ).ordered

    expect { subject.call env }.to raise_error( Interrupt )
  end
  it 'returns env' do
    subject.stub :hipchat => true # FIXME bad testing. need to create another object for this
    subject.call( env ).should == env
  end
end
