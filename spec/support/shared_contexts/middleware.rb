shared_context 'middleware', :middleware => true do

  ##
  # A test double for the remote object.
  let( :remote ){ double 'remote',
    :name    => 'staging',
    :heroku? => nil,
    :to_s    => 'staging' }

  ##
  # A test double for the branch object.
  let( :branch ){ double 'branch',
    :name => 'develop',
    :full => 'develop',
    :to_s => 'develop' }

  ##
  # The request env
  let( :env ){ [ remote, branch ] }

  ##
  # A simple app lambda.
  let( :app ){ lambda { |env| env } }

  ##
  # A placeholder options hash.
  let( :options ){ { } }

  ##
  # Instantiate the middleware.
  subject { described_class.new app, options }

  ##
  # A helper method for declaring ordered method expectations.
  def step( receiver, method, *args )
    receiver.should_receive( method ).with( *args ).ordered.and_call_original
  end

  ##
  # Stub this system's user.
  before { subject.stub :user => 'jeremy.ruppel@gmail.com' }

  ##
  # Add hooks for making the remote behave like a heroku remote.
  before( :heroku => true ){ remote.stub :heroku? => 0  }

  ##
  # Silence the middleware shell during test runs.
  around { |example| subject.shell.mute { example.run } }
end
