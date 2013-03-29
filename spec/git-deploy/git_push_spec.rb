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
  it 'sets the force flag if the option is given' do
    env[ 'options.force' ] = true

    subject.should_receive( :` ).with( 'git push production feature --force' ).ordered { `test true` }
        app.should_receive( :call ).with( env ).ordered.and_call_original

    subject.call env
  end

  describe '.configure' do
    it 'adds the correct option' do
      opts = double 'Slop'
      opts.should_receive( :on ).with( :f, :force, an_instance_of( String ) )
      described_class.configure opts
    end
  end
end
