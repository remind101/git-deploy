require 'spec_helper'

describe Git::Deploy::Middleware::Sanity, :middleware => true do

  subject { described_class.new app }

  context 'when the remote is blank' do
    let( :remote ){ nil }
    before { subject.stub :current_remote => nil } # FIXME bad collaboration, object has too much responsibility

    it 'raises an error' do
      expect { subject.call( env ) }.to raise_error( ArgumentError )
    end
  end

  it 'returns env' do
    subject.call( env ).should == env
  end
end
