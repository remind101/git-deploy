require 'spec_helper'

describe Git::Deploy::HerokuMaintenance, :middleware => true do

  subject { described_class.new app }

  it 'enters maintenance mode around the deploy if the remote is heroku' do
    env[ 'options.maintenance' ] = true
    env[ 'remote.heroku' ] = true

    subject.should_receive( :` ).with( 'heroku maintenance:on --remote production' ).ordered
        app.should_receive( :call ).with( env ).ordered.and_call_original
    subject.should_receive( :` ).with( 'heroku maintenance:off --remote production' ).ordered

    subject.call env
  end
  it 'does not enable maintenance mode if the remote is not heroku' do
    env[ 'options.maintenance' ] = true
    env[ 'remote.heroku' ] = false

    subject.should_not_receive( :` )
        app.should_receive( :call ).with( env ).ordered.and_call_original

    subject.call env
  end
  it 'does not enable maintenance mode if the option is false' do
    env[ 'options.maintenance' ] = false
    env[ 'remote.heroku' ] = true

    subject.should_not_receive( :` )
        app.should_receive( :call ).with( env ).ordered.and_call_original

    subject.call env
  end
  it 'turns maintenance mode back off after an interrupt' do
    env[ 'options.maintenance' ] = true
    env[ 'remote.heroku' ] = true

    subject.should_receive( :` ).with( 'heroku maintenance:on --remote production' ).ordered
        app.should_receive( :call ).with( env ).ordered.and_raise( Interrupt )
    subject.should_receive( :` ).with( 'heroku maintenance:off --remote production' ).ordered

    expect { subject.call( env ) }.to raise_error( Interrupt )
  end
end
