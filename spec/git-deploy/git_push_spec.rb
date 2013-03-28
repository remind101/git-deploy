require 'spec_helper'

describe Git::Deploy::GitPush, :middleware => true do

  subject { described_class.new app }

  it 'performs the correct steps in order' do
    subject.should_receive( :` ).with( 'git push production feature' ).ordered { `test true` }
        app.should_receive( :call ).with( env ).ordered.and_call_original

    subject.call env
  end
  it 'raises an interrupt if the push fails' do
    subject.should_receive( :` ).with( 'git push production feature' ).ordered { `test ! true` }
        app.should_not_receive( :call )

    expect { subject.call( env ) }.to raise_error( Interrupt )
  end
end
