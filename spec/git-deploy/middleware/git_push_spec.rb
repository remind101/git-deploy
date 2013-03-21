require 'spec_helper'

describe Git::Deploy::Middleware::GitPush, :middleware => true do

  subject { described_class.new app }

  let( :git ){ double( 'Git' ).as_null_object }

  before { Git::Deploy::Remote.stub :new => git }

  it 'performs the correct steps in order' do
    git.should_receive( :push ).ordered
    app.should_receive( :call ).with( env ).ordered.and_call_original

    subject.call env
  end
  it 'returns env' do
    subject.call( env ).should == env
  end
end
