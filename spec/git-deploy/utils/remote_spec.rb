require 'spec_helper'

describe Git::Deploy::Utils::Remote do

  let( :env ){ [ { }, 'production', 'master', '--force', '-v' ] }

  subject { described_class.new env }

  let( :shell ){ Git::Deploy::Utils::Shell }

  describe '#heroku?' do
    it 'returns truthy when the remote url looks like heroku' do
      shell.should_receive( :[] ).with( 'git config remote.production.url' ){ 'git@heroku.com:mysite.git' }
      subject.should be_heroku
    end
    it 'returns falsy when the remote url does not look like heroku' do
      shell.should_receive( :[] ).with( 'git config remote.production.url' ){ 'git@github.com:mysite.git' }
      subject.should_not be_heroku
    end
  end
end
