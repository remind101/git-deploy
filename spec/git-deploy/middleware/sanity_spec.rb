require 'spec_helper'

describe Git::Deploy::Middleware::Sanity, :middleware => true do

  subject { described_class.new app }

  describe 'remote argument' do
    before { subject.stub :branch_exists? => true }

    it 'leaves the remote alone if it exists' do
      env[ 'remote' ] = 'production'
      subject.stub :remote_exists? => true
      subject.call env
      env[ 'remote' ].should == 'production'
    end
    it 'sets the remote to the current remote if it is not provided' do
      env[ 'remote' ] = nil
      subject.stub :current_remote => 'production'
      subject.stub :remote_exists? => true
      subject.call env
      env[ 'remote' ].should == 'production'
    end
    it 'raises an error if the remote does not exist' do
      env[ 'remote' ] = 'asdf'
      subject.stub :remote_exists? => false
      expect { subject.call( env ) }.to raise_error( ArgumentError, /Remote 'asdf' does not exist/ )
    end
  end

  describe 'branch argument' do
    before { subject.stub :remote_exists? => true }

    it 'leaves the branch alone if it exists' do
      env[ 'branch' ] = 'master'
      subject.stub :branch_exists? => true
      subject.call env
      env[ 'branch' ].should == 'master'
    end
    it 'sets the branch to the current branch if it is not provided' do
      env[ 'branch' ] = nil
      subject.stub :current_branch => 'master'
      subject.stub :branch_exists? => true
      subject.call env
      env[ 'branch' ].should == 'master'
    end
    it 'raises an error if the branch does not exist' do
      env[ 'branch' ] = 'asdf'
      subject.stub :branch_exists? => false
      expect { subject.call( env ) }.to raise_error( ArgumentError, /Branch 'asdf' does not exist/ )
    end
  end

end
