require 'spec_helper'

describe Git::Deploy::Hipchat, :middleware => true do

  subject { described_class.new app, { } }

  it 'performs the correct steps in order' do
    env[ 'git.config.hipchat.authtoken' ] = 'foo'
    env[ 'git.config.user.email'        ] = 'jeremy.ruppel@gmail.com'

    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com is deploying feature to production', :color => 'yellow').ordered
        app.should_receive( :call ).with( env ).ordered.and_call_original
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com successfully deployed feature to production', :color => 'green').ordered

    subject.call env
  end
  it 'ouputs the name of the heroku app, when the user is deploying to heroku' do
    env[ 'git.config.hipchat.authtoken' ] = 'foo'
    env[ 'git.config.user.email'        ] = 'jeremy.ruppel@gmail.com'
    env[ 'remote.heroku'                ] = true
    env[ 'remote.app'                   ] = 'app'

    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com is deploying app#feature to production', :color => 'yellow').ordered
        app.should_receive( :call ).with( env ).ordered.and_call_original
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com successfully deployed app#feature to production', :color => 'green').ordered

    subject.call env
  end
  it 'handles an interrupt' do
    env[ 'git.config.hipchat.authtoken' ] = 'foo'
    env[ 'git.config.user.email'        ] = 'jeremy.ruppel@gmail.com'

    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com is deploying feature to production', :color => 'yellow').ordered
        app.should_receive( :call ).with( env ).ordered.and_raise( Interrupt )
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com interrupted the deploy of feature to production', :color => 'red').ordered

    expect { subject.call( env ) }.to raise_error( Interrupt )
  end
  it 'raises an exception when the auth token is not set' do
    env[ 'git.config.hipchat.authtoken' ] = nil

    subject.should_not_receive( :hipchat )
        app.should_not_receive( :call )

    expect { subject.call( env ) }.to raise_error( ArgumentError )
  end
end
