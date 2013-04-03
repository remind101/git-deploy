require 'spec_helper'

# Make #stack public for testing
class Git::Deploy::Runner
  public :stack
end

describe Git::Deploy::Runner, :focus => true do

  let( :opts ){ double 'Slop' }

  subject { described_class.new opts }

  it 'has the correct default middleware stack' do
    subject.stack.should == [
      [ Git::Deploy::GitConfig, [ ], nil ]
    ]
  end
end
