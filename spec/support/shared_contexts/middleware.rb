shared_context 'middleware', :middleware => true do

  ##
  # A test double for the options. Explicitly stub your options under test
  # on this object.
  let( :options ){ double( 'options' ).as_null_object }

  ##
  # The remote name.
  let( :remote ){ 'production' }

  ##
  # The branch name.
  let( :branch ){ 'feature' }

  ##
  # The env array.
  let( :env ){ {
    'remote' => remote.freeze,
    'branch' => branch.freeze,
    'args'   => nil
  } }

  ##
  # An app to hand to your middleware. Does absolutely nothing.
  let( :app ){ lambda { |env| } }
end
