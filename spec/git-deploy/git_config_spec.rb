require 'spec_helper'

describe Git::Deploy::GitConfig, :middleware => true do

  subject { described_class.new app }

  it 'adds all git configs to env["git.config.*"]' do
    subject.stub( :` ){ '' }
    subject.stub( :` ).with( 'git config --list' ){ <<-EOS
deploy.develop.remote=staging
deploy.master.remote=production
deploy.foo=bar
remote.production.url=git@heroku.com:app.git
remote.production.merge=refs/heads/master
user.email=jeremy.ruppel@gmail.com
EOS
    }

    subject.call env

    env.should include(
      'git.config.deploy.develop.remote'   => 'staging',
      'git.config.deploy.master.remote'    => 'production',
      'git.config.deploy.foo'              => 'bar',
      'git.config.remote.production.url'   => 'git@heroku.com:app.git',
      'git.config.remote.production.merge' => 'refs/heads/master',
      'git.config.user.email'              => 'jeremy.ruppel@gmail.com'
    )
  end
  it 'adds the current branch to env' do
    subject.stub( :` ){ '' }
    subject.stub( :` ).with( 'git symbolic-ref --short HEAD' ){ `echo develop` }

    subject.call env

    env.should include( 'git.branch' => 'develop' )
  end
  it 'adds the current remote to env' do
    subject.stub( :` ){ '' }
    subject.stub( :` ).with( 'git rev-parse --abbrev-ref --verify --quiet @{u}' ){ `echo production` }

    subject.call env

    env.should include( 'git.remote' => 'production' )
  end
end
