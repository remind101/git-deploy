require 'spec_helper'

describe Git::Deploy::Hipchat, :middleware => true do

  subject { described_class.new app, { } }

  it 'performs the correct steps in order' do
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com is deploying feature to production', :color => 'yellow' ).ordered
        app.should_receive( :call ).with( env ).ordered.and_call_original
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com successfully deployed feature to production', :color => 'green' ).ordered

    subject.call env
  end
  it 'handles an interrupt' do
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com is deploying feature to production', :color => 'yellow' ).ordered
        app.should_receive( :call ).with( env ).ordered.and_raise( Interrupt )
    subject.should_receive( :hipchat ).with( 'jeremy.ruppel@gmail.com interrupted the deploy of feature to production', :color => 'red' ).ordered

    expect { subject.call env }.to raise_error( Interrupt )
  end
end
