require 'spec_helper'

describe Git::Deploy::Hipchat, :middleware => true do

  subject { described_class.new app, { } }

  it 'performs the correct steps in order' do
    env[ 'deploy.hipchat.auth_token' ] = 'foo'
    subject.should_receive( :` ).with( 'git config user.email' ) { "jeremy.ruppel@gmail.com\n" }
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com is deploying feature to production', :color => 'yellow', :auth_token => 'foo' ).ordered
        app.should_receive( :call ).with( env ).ordered.and_call_original
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com successfully deployed feature to production', :color => 'green', :auth_token => 'foo' ).ordered

    subject.call env
  end
  it 'handles an interrupt' do
    env[ 'deploy.hipchat.auth_token' ] = 'foo'

    subject.should_receive( :` ).with( 'git config user.email' ) { "jeremy.ruppel@gmail.com\n" }
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com is deploying feature to production', :color => 'yellow', :auth_token => 'foo' ).ordered
        app.should_receive( :call ).with( env ).ordered.and_raise( Interrupt )
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com interrupted the deploy of feature to production', :color => 'red', :auth_token => 'foo' ).ordered

    expect { subject.call( env ) }.to raise_error( Interrupt )
  end
  it 'raises an exception when the auth token is not set' do
    env[ 'deploy.hipchat.auth_token' ] = nil

    subject.should_not_receive( :hipchat )
        app.should_not_receive( :call )

    expect { subject.call( env ) }.to raise_error( ArgumentError )
  end
end
