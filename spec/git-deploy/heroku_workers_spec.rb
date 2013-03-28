require 'spec_helper'

describe Git::Deploy::HerokuWorkers, :middleware => true do

  subject { described_class.new app }

  it 'scales the workers when the remote is heroku' do
    env[ 'remote.heroku' ] = true

    subject.should_receive( :` ).with( 'heroku ps --remote production | grep -c worker' ).ordered { "2\n" }
    subject.should_receive( :` ).with( 'heroku ps:scale worker=0 --remote production' ).ordered
        app.should_receive( :call ).with( env )
    subject.should_receive( :` ).with( 'heroku ps:scale worker=2 --remote production' ).ordered

    subject.call env
  end
  it 'does not scale workers when the remote is not heroku' do
    env[ 'remote.heroku' ] = false

    subject.should_not_receive( :` )
        app.should_receive( :call ).with( env )

    subject.call env
  end
  it 'scales the workers back up after an interrupt' do
    env[ 'remote.heroku' ] = true

    subject.should_receive( :` ).with( 'heroku ps --remote production | grep -c worker' ).ordered { "2\n" }
    subject.should_receive( :` ).with( 'heroku ps:scale worker=0 --remote production' ).ordered
        app.should_receive( :call ).with( env ).and_raise( Interrupt )
    subject.should_receive( :` ).with( 'heroku ps:scale worker=2 --remote production' ).ordered

    expect { subject.call( env ) }.to raise_error( Interrupt )
  end
end
