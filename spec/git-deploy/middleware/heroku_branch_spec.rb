require 'spec_helper'

describe Git::Deploy::Middleware::HerokuBranch, :middleware => true do

  subject { described_class.new app }

  it 'appends :master to the branch when the remote is heroku' do
    env[ 'remote.heroku' ] = true
    env[ 'branch'        ] = 'feature'
    subject.call( env )
    env[ 'branch' ].should == 'feature:master'
  end
  it 'does not append :master to the branch when the remote is not heroku' do
    env[ 'remote.heroku' ] = false
    env[ 'branch'        ] = 'feature'
    subject.call( env )
    env[ 'branch' ].should == 'feature'
  end
  it 'does not append :master to the branch when the branch is master' do
    env[ 'remote.heroku' ] = true
    env[ 'branch'        ] = 'master'
    subject.call( env )
    env[ 'branch' ].should == 'master'
  end
end
