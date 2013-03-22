module Git
  module Deploy
    class Runner

      ##
      # Sets up the middleware stack for deploy runs. Every middleware gets
      # access to the thor runner's options hash, as well as its own options
      # hash and block.
      def initialize( builder )
        @builder = builder
      end

      ##
      # Turn Slop's multiple arguments to #call into an array. Also,
      # rescue errors and report them to the user appropriately.
      def call( *args )
        @builder.call args.flatten
      rescue Interrupt => e
        puts e.message.red
        exit 1
      rescue ArgumentError => e
        puts e.message
        puts args.first # prints the usage instructions
        exit 1
      end

    end
  end
end
