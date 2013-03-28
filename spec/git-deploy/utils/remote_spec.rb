require 'spec_helper'

describe Git::Deploy::Utils::Remote, :middleware => true do

  subject { described_class.new app }

  describe '#remotes' do

    it 'returns a hash of remote names and urls' do
      subject.stub :` => <<-EOS
origin	git@github.com:jeremyruppel/git-deploy.git (fetch)
origin	git@github.com:jeremyruppel/git-deploy.git (push)
heroku	git@heroku.com:mysite.git (fetch)
heroku	git@heroku.com:mysite.git (push)
      EOS
      subject.remotes.should == {
        'origin' => 'git@github.com:jeremyruppel/git-deploy.git',
        'heroku' => 'git@heroku.com:mysite.git'
      }
    end
  end

  describe 'remote.url' do

    it 'is set to the git url' do
      subject.stub :remotes => { remote => 'git@heroku.com:mysite.git' }
      subject.call( env )
      env[ 'remote.url' ].should == 'git@heroku.com:mysite.git'
    end
    it 'raises an exception if the url cannot be found' do
      subject.stub :remotes => { }
      env[ 'remote' ] = '-f'
      expect { subject.call( env ) }.to raise_error
    end
  end

  describe 'remote.heroku' do

    it 'is true if the remote is on heroku' do
      env[ 'remote.url' ] = 'git@heroku.com:mysite.git'
      subject.call( env )
      env[ 'remote.heroku' ].should == true
    end

    it 'is false if the remote is not on heroku' do
      env[ 'remote.url' ] = 'git@github.com:mysite.git'
      subject.call( env )
      env[ 'remote.heroku' ].should == false
    end
  end
end
