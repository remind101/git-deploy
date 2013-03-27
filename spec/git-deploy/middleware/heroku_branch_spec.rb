require 'spec_helper'

describe Git::Deploy::Middleware::HerokuBranch, :middleware => true do

  subject { described_class.new app }

  let( :branch ){ 'feature'.freeze }

  on_heroku do
    it 'returns env' do
      subject.call( env ).should == [ options, remote, 'feature:master' ]
    end
  end

  off_heroku do
    it 'returns env' do
      subject.call( env ).should == env
    end
  end
end
