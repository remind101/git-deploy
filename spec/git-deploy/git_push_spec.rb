require 'spec_helper'

describe Git::Deploy::GitPush, :middleware => true do

  subject { described_class.new app }

  it 'performs the correct steps in order' do
    subject.should_receive( :` ).with( 'git push production feature' ).ordered
        app.should_receive( :call ).with( env ).ordered.and_call_original

    subject.call env
  end
end
