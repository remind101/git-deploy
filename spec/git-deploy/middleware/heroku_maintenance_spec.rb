require 'spec_helper'

describe Git::Deploy::Middleware::HerokuMaintenance, :middleware => true do

  subject { described_class.new app }

  let( :heroku ){ double( 'Heroku' ).as_null_object }

  before { Git::Deploy::Utils::Heroku.stub :new => heroku }

  on_heroku do
    it 'performs the correct steps in order' do
      heroku.should_receive( :maintenance_on ).ordered
         app.should_receive( :call ).with( env ).ordered.and_call_original
      heroku.should_receive( :maintenance_off ).ordered

      subject.call env
    end
    it 'handles an interrupt' do
      heroku.should_receive( :maintenance_on ).ordered
         app.should_receive( :call ).with( env ).ordered.and_raise( Interrupt )
      heroku.should_receive( :maintenance_off ).ordered

      expect { subject.call env }.to raise_error( Interrupt )
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
