require 'spec_helper'

describe Git::Deploy::Middleware::GitPush, :middleware => true do

  subject { described_class.new app }

  it 'performs the correct steps in order' do
    subject.should_receive( :`    ).with( 'git push production master' ).ordered { true }
        app.should_receive( :call ).with( env ).ordered.and_call_original

    subject.call env
  end
  it 'returns env' do
    subject.call( env ).should == env
  end
end
