require 'spec_helper'

describe Git::Deploy::Middleware::Sanity, :middleware => true do

  subject { described_class.new app }

  let( :git ){ double( 'Git' ).as_null_object }

  before { Git::Deploy::Utils::Git.stub :new => git }

  context 'when the remote is blank' do
    let( :remote ){ nil }

    before { git.stub :current_remote => '' }

    it 'raises an error' do
      expect { subject.call( env ) }.to raise_error( ArgumentError )
    end
  end

  it 'returns env' do
    subject.call( env ).should == env
  end
end
