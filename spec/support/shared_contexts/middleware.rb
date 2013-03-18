shared_context 'middleware', :middleware => true do

  ##
  # A test double for the remote object.
  let( :remote ){ double 'remote', :name => 'staging', :heroku? => 0, :to_s => 'staging' }

  ##
  # A test double for the refspec object.
  let( :refspec ){ double 'refspec', :name => 'develop', :to_s => 'develop' }

  ##
  # The request env
  let( :env ){ [ remote, refspec ] }

  ##
  # A simple app lambda.
  let( :app ){ lambda { |env| env } }

  ##
  # A helper method for declaring ordered method expectations.
  def step( receiver, method, *args )
    receiver.should_receive( method ).with( *args ).ordered.and_call_original
  end

  ##
  # Stub this system's user.
  before { subject.stub :user => 'jeremy.ruppel@gmail.com' }

  ##
  # Silence the middleware shell during test runs.
  around { |example| subject.shell.mute { example.run } }
end
