require 'spec_helper'

describe Git::Deploy::GitTag, :middleware => true do

  around do |example|
    Timecop.freeze 2013, 4, 12 do
      example.run
    end
  end

  subject { described_class.new app, {
    :tagname => '%F',
    :message => 'Deploying because its %A!'
  } }

  describe '#call' do
    it 'tags the release correctly' do
      env[ 'options.tag' ] = true

      subject.should_receive( :sh )
        .with( 'git tag "2013-04-12" -m "Deploying because its Friday!"' ).ordered
      subject.should_receive( :sh )
        .with( 'git push origin --tags' ).ordered
      app.should_receive( :call ).with( env ).ordered

      subject.call env
    end
    it 'does not tag the release if the option is not given' do
      env[ 'options.migrate' ] = nil

      subject.should_not_receive :sh
      app.should_receive( :call ).with env

      subject.call env
    end
  end
end
