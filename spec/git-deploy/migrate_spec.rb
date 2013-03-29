require 'spec_helper'

describe Git::Deploy::Migrate, :middleware => true do

  subject { described_class.new app }

  it 'runs migrations if the option is specified' do
    env[ 'options.migrate' ] = true
    env[ 'remote.heroku'   ] = true

        app.should_receive( :call ).with( env ).ordered.and_call_original
    subject.should_receive( :` ).with( 'heroku run rake db:migrate --remote production' ).ordered

    subject.call env
  end
  it 'does not run migrations if the option is not specified' do
    env[ 'options.migrate' ] = nil
    env[ 'remote.heroku'   ] = true

    subject.should_not_receive( :` )
        app.should_receive( :call ).with( env ).ordered.and_call_original

    subject.call env
  end
  it 'does not run migrations if the remote is not heroku' do
    env[ 'options.migrate' ] = true
    env[ 'remote.heroku'   ] = false

    subject.should_not_receive( :` )
        app.should_receive( :call ).with( env ).ordered.and_call_original

    subject.call env
  end
end
