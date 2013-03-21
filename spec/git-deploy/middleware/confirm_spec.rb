require 'spec_helper'

describe Git::Deploy::Middleware::Confirm, :middleware => true do

  subject { described_class.new app }

  describe '#call' do

    it 'asks the user to confirm the deployment' do
      subject.shell.should_receive( :agree )
                   .with( 'Deploy master to production?' ){ true }

      subject.call env
    end

    context 'when the user agrees' do
      before { subject.shell.stub :agree => true }

      it 'does not raise an error' do
        expect { subject.call( env ) }.not_to raise_error
      end
      it 'returns env' do
        subject.call( env ).should == env
      end
    end

    context 'when the user does not agree' do
      before { subject.shell.stub :agree => false }

      it 'raises an error' do
        expect { subject.call( env ) }.to raise_error( Interrupt )
      end
    end
  end
end
