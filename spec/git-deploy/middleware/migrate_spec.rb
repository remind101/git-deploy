require 'spec_helper'

describe Git::Deploy::Middleware::Migrate, :middleware => true do

  subject { described_class.new app }

  let( :heroku ){ double( 'Heroku' ).as_null_object }

  before { Git::Deploy::Utils::Heroku.stub :new => heroku }

  on_heroku do
    it 'runs migrations when the option is specified' do
      options.stub :migrate? => true

         app.should_receive( :call ).with( env ).ordered.and_call_original
      heroku.should_receive( :run  ).with( 'rake db:migrate' ).ordered

      subject.call env
    end
    it 'returns env' do
      subject.call( env ).should == env
    end
  end

  off_heroku do

    it 'returns env' do
      subject.call( env ).should == env
    end
  end
end
