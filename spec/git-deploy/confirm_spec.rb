require 'spec_helper'

describe Git::Deploy::Confirm, :middleware => true do

  subject { described_class.new app }

  describe '#call' do

    it 'asks the user to confirm the deployment' do
      env[ 'options.confirm' ] = true
      subject.should_receive( :confirm? ).with( remote, branch ){ true }
      subject.call env
    end
    it 'raises an error if the user does not confirm the deployment' do
      env[ 'options.confirm' ] = true
      subject.should_receive( :confirm? ).with( remote, branch ){ false }
      expect { subject.call( env ) }.to raise_error( Interrupt )
    end
    it 'does not ask the user if the option is not given' do
      env[ 'options.confirm' ] = false
      subject.should_not_receive( :confirm? )
      subject.call env
    end
  end

  describe '.configure' do
    it 'adds the correct option' do
      opts = double 'Slop'
      opts.should_receive( :on ).with( :c, :confirm, an_instance_of( String ) )
      described_class.configure opts
    end
  end
end
