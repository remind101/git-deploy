require 'spec_helper'

describe Git::Deploy::Shell do

  subject { Class.new do
    include Git::Deploy::Shell
  end.new }

  describe '#sh' do
    it 'executes the given command' do
      subject.sh( 'echo it werks' ).should == 'it werks'
    end
    it 'yields to the block if given' do
      expect { |blk| subject.sh( 'echo it werks', &blk ) }
        .to yield_with_args( 'it werks' )
    end
    it 'yields successive lines if a block is given' do
      expect { |blk| subject.sh( "head -n 3 #{__FILE__}", &blk ) }
        .to yield_successive_args(
          "require 'spec_helper'",
          "",
          "describe Git::Deploy::Shell do"
         )
    end
    it 'returns nil if the command has no output' do
      subject.sh( 'echo' ).should == nil
    end
    it 'does not yield to the block if the command has no output' do
      expect { |blk| subject.sh( 'echo', &blk ) }.not_to yield_control
    end
  end

  describe '#sh?' do
    it 'executes the given command' do
      subject.sh?( 'echo it works' ).should == true
    end
    it 'returns false if the command does not exit with success' do
      subject.sh?( 'test ! true' ).should == false
    end
    it 'yields to the block if given' do
      expect { |blk| subject.sh( 'echo it werks', &blk ) }
        .to yield_with_args( 'it werks' )
    end
    it 'yields successive lines if a block is given' do
      expect { |blk| subject.sh( "head -n 3 #{__FILE__}", &blk ) }
        .to yield_successive_args(
          "require 'spec_helper'",
          "",
          "describe Git::Deploy::Shell do"
         )
    end
  end
end
