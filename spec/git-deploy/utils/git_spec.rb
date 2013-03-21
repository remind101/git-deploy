require 'spec_helper'

describe Git::Deploy::Utils::Git do

  let( :env ){ [ { }, 'production', 'master', '--force', '-v' ] }

  subject { described_class.new env }

  let( :shell ){ Git::Deploy::Utils::Shell }

  describe '#push' do
    it 'executes the correct subcommand' do
      shell.should_receive( :[] ).with( 'git push production master --force -v' ){ '...' }
      subject.push.should == '...'
    end
  end

  describe '#current_branch' do
    it 'executes the correct subcommand' do
      shell.should_receive( :[] ).with( 'git symbolic-ref HEAD' ){ '...' }
      subject.current_branch.should == '...'
    end
  end

  describe '#current_remote' do
    it 'executes the correct subcommand' do
      subject.stub :current_branch => 'master'
      shell.should_receive( :[] ).with( 'git config deploy.master.remote' ){ '...' }
      subject.current_remote.should == '...'
    end
  end

  describe '#current_remote?' do
    it 'returns true if there is a current remote' do
      subject.stub :current_remote => 'master'
      subject.should be_current_remote
    end
    it 'returns false if there is not a current remote' do
      subject.stub :current_remote => ''
      subject.should_not be_current_remote
    end
  end
end
