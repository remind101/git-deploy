require 'spec_helper'
require 'git-deploy/middleware/hipchat'

describe Git::Deploy::Middleware::Hipchat, :middleware => true do

  subject { described_class.new app }

  it { should be_a( Git::Deploy::Middleware ) }

  it 'performs the correct steps in order' do
    step subject, :sh,   'hipchat', "say '[FILTERED]' --color yellow --auth-token [FILTERED] --room-id Developers --from Deploy"
    step app,     :call, env
    step subject, :sh,   'hipchat', "say '[FILTERED]' --color yellow --auth-token [FILTERED] --room-id Developers --from Deploy"

    subject.call env
  end
  it 'returns env' do
    subject.call( env ).should == env
  end
end
