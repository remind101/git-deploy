require 'spec_helper'

describe Git::Deploy::GitRemote, :middleware => true do

  subject { described_class.new app }

  describe '#call' do
    it 'uses the remote if provided' do
      env[ 'remote' ] = 'staging'

      subject.should_receive( :remote_exists? ){ true }
      subject.call env

      env[ 'remote' ].should == 'staging'
    end
    it 'determines the current remote if missing' do
      env[ 'remote' ] = nil
      env[ 'branch' ] = 'master'
      env[ 'git.config.branch.master.remote' ] = 'foo'

      subject.should_receive( :remote_exists? ){ true }
      subject.call env

      env[ 'remote' ].should == 'foo'
    end
    it 'raises an exception if the remote cannot be determined' do
      env[ 'remote' ] = nil

      subject.should_not_receive( :remote_exists? )

      expect { subject.call( env ) }.to raise_error( ArgumentError )
    end
    it 'raises an execption if the remote does not exist' do
      env[ 'remote' ] = 'asdf'

      subject.should_receive( :remote_exists? ){ false }

      expect { subject.call( env ) }.to raise_error( ArgumentError )
    end
  end
  describe '#remote_exists?' do
    it 'shells out the correct command' do
      subject.should_receive( :system ).with( 'git show-ref --quiet --verify refs/remotes/foo/master' )
      subject.remote_exists? 'foo'
    end
  end
end
