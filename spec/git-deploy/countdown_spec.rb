require 'spec_helper'

describe Git::Deploy::Countdown, :middlware => true do

  describe '.configure' do
    it 'adds the correct option' do
      opts = double 'Slop'
      opts.should_receive( :on ).with( :c, :countdown, an_instance_of( String ) )
      described_class.configure opts
    end
  end
end
