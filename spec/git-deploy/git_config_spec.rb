require 'spec_helper'

describe Git::Deploy::GitConfig, :middleware => true do

  subject { described_class.new app }

  it 'adds all git configs under the deploy key to env' do
    subject.should_receive( :` ).with( 'git config --get-regexp deploy.*' ){ <<-EOS
deploy.develop.remote staging
deploy.master.remote production
deploy.foo bar
EOS
    }

    subject.call env

    env.should include(
      'deploy.develop.remote' => 'staging',
      'deploy.master.remote'  => 'production',
      'deploy.foo'            => 'bar'
    )
  end
end
