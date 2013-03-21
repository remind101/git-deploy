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
  let( :branch ){ 'master' }

  ##
  # The env array.
  let( :env ){ [ options, remote, branch ] }

  ##
  # An app to hand to your middleware. Does absolutely nothing.
  let( :app ){ lambda { |env| env } }
end

module HerokuContexts

  def on_heroku( &block )
    context 'when the remote is a heroku app' do
      let( :remote ){ double( 'Remote', :heroku? => true ).as_null_object }

      before { Git::Deploy::Utils::Remote.stub :new => remote }

      instance_exec &block
    end
  end

  def off_heroku( &block )
    context 'when the remote is not a heroku app' do
      let( :remote ){ double( 'Remote', :heroku? => false ).as_null_object }

      before { Git::Deploy::Utils::Remote.stub :new => remote }

      instance_exec &block
    end
  end
end

RSpec.configure do |c|
  c.extend HerokuContexts, :middleware => true
end
