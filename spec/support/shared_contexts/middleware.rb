shared_context 'middleware', :middleware => true do

  ##
  # A test double for the remote object.
  let( :remote ){ double 'remote', :name => 'foo' }

  ##
  # A test double for the refspec object.
  let( :refspec ){ double 'refspec', :name => 'bar' }

  ##
  # The request env
  let( :env ){ [ remote, refspec ] }

  ##
  # A simple app lambda.
  let( :app ){ lambda { |env| env } }

  ##
  # A helper method for declaring ordered method expectations.
  def step( receiver, method, *args )
    receiver.should_receive( method ).with( *args ).ordered
  end
end
