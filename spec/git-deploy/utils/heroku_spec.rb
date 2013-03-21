require 'spec_helper'

describe Git::Deploy::Utils::Heroku do

  let( :env ){ [ { }, 'production', 'master', '--force', '-v' ] }

  subject { described_class.new env }

  let( :shell ){ Git::Deploy::Utils::Shell }

  describe '#maintenance_on' do
    it 'executes the correct subcommand' do
      shell.should_receive( :[] ).with( 'heroku maintenance:on --remote production' ){ '...' }
      subject.maintenance_on.should == '...'
    end
  end

  describe '#maintenance_off' do
    it 'executes the correct subcommand' do
      shell.should_receive( :[] ).with( 'heroku maintenance:off --remote production' ){ '...' }
      subject.maintenance_off.should == '...'
    end
  end

  describe '#ps' do
    it 'executes the correct subcommand' do
      shell.should_receive( :[] ).with( 'heroku ps --remote production' ){ <<-EOS
=== web: `bundle exec`
web.1: up 2013/03/21 07:30:43 (~ 4h ago)
web.2: up 2013/03/21 07:30:43 (~ 4h ago)

=== worker: `bundle exec`
worker.1: up 2013/03/21 07:30:16 (~ 4h ago)

EOS
      }
      subject.ps.should == {
        :web => [
          'web.1: up 2013/03/21 07:30:43 (~ 4h ago)',
          'web.2: up 2013/03/21 07:30:43 (~ 4h ago)'
        ],
        :worker => [
          'worker.1: up 2013/03/21 07:30:16 (~ 4h ago)'
        ]
      }
    end
  end

  describe '#ps_scale' do
    it 'executes the correct subcommand' do
      shell.should_receive( :[] ).with( 'heroku ps:scale worker=99 --remote production' ){ '...' }
      subject.ps_scale( :worker => 99 ).should == '...'
    end
  end

  describe '#run' do
    it 'executes the correct subcommand' do
      shell.should_receive( :[] ).with( 'heroku run cowsay --remote production' ){ '...' }
      subject.run( 'cowsay' ).should == '...'
    end
  end
end
