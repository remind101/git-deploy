require 'spec_helper'

describe Git::Deploy do

  subject { described_class }

  describe '.root' do
    it 'returns a pathname' do
      subject.root.should be_a( Pathname )
    end
    it 'runs the correct command' do
      subject.should_receive( :` ).with( 'git rev-parse --show-toplevel' ){ 'foo' }
      subject.root.to_path.should == 'foo'
    end
  end

  describe '.on_deployable_branch?' do
    it 'is false if there is not a deploy remote set up for this branch' do
      # TODO exit status should be 1
      subject.should_receive( :system ).with( 'git config deploy.$(basename $(git symbolic-ref HEAD)).remote' ){ false }
      subject.on_deployable_branch?.should == false
    end
    it 'is true if there is a deploy remote set up for this branch' do
      # TODO exit status should be 0
      subject.should_receive( :system ).with( 'git config deploy.$(basename $(git symbolic-ref HEAD)).remote' ){ true }
      subject.on_deployable_branch?.should == true
    end
  end

  describe '.verbose' do
    it 'is an accessor' do
      subject.should respond_to( :verbose, :verbose= )
    end
  end
end
