require 'spec_helper'

describe Git::Deploy::GitBranch, :middleware => true do

  subject { described_class.new app }

  describe '#call' do
    it 'uses the branch if provided' do
      env[ 'branch' ] = 'master'

      subject.should_not_receive( :current_branch )
      subject.should_receive( :branch_exists? ){ true }
      subject.call env

      env[ 'branch' ].should == 'master'
    end
    it 'determines the current branch if missing' do
      env[ 'branch' ] = nil

      subject.should_receive( :current_branch ){ 'foo' }
      subject.should_receive( :branch_exists? ){ true }
      subject.call env

      env[ 'branch' ].should == 'foo'
    end
    it 'raises an execption if the branch does not exist' do
      env[ 'branch' ] = 'asdf'

      subject.should_not_receive( :current_branch )
      subject.should_receive( :branch_exists? ){ false }

      expect { subject.call( env ) }.to raise_error( ArgumentError )
    end
  end
  describe '#current_branch' do
    it 'shells out the correct command' do
      subject.should_receive( :` ).with( 'git symbolic-ref --short HEAD' ){ "chomped\n" }
      subject.current_branch.should == 'chomped'
    end
  end
  describe '#branch_exists?' do
    it 'shells out the correct command' do
      subject.should_receive( :system ).with( 'git show-ref --quiet --verify refs/heads/foo' )
      subject.branch_exists? 'foo'
    end
  end
end
