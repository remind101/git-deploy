require 'spec_helper'

describe Git::Deploy::Middleware::HerokuBranch, :middleware => true do

  subject { described_class.new app }

  on_heroku do
    it 'targets the push to the master branch of the heroku remote' do
      expect { subject.call( env ) }.to change { branch }.to( 'master:master' )
    end
    it 'returns env' do
      subject.call( env ).should == env
    end
  end

  off_heroku do
    it 'does not alter the destination branch' do
      expect { subject.call( env ) }.not_to change { branch }
    end
    it 'returns env' do
      subject.call( env ).should == env
    end
  end
end
