require 'spec_helper'

describe Git::Deploy::Middleware::HerokuWorkers, :middleware => true do

  subject { described_class.new app }

  let( :heroku ){ double( 'Heroku' ).as_null_object }

  before { Git::Deploy::Heroku.stub :new => heroku }

  on_heroku do
    it 'performs the correct steps in order' do
      heroku.should_receive( :ps ).ordered { { :worker => 1 } }
      heroku.should_receive( :ps_scale ).with( :worker => 0 ).ordered
         app.should_receive( :call ).with( env ).ordered.and_call_original
      heroku.should_receive( :ps_scale ).with( :worker => 1 ).ordered

      subject.call env
    end
    it 'returns env' do
      subject.call( env ).should == env
    end
  end

  off_heroku do
    it 'performs the correct steps in order' do
      app.should_receive( :call ).with( env ).ordered.and_call_original

      subject.call env
    end
    it 'returns env' do
      subject.call( env ).should == env
    end
  end
end
