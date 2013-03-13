require 'pathname'

module Git
  module Deploy
    class Paths < Struct.new( :base )

      def root
        Pathname.new( base ).dirname.dirname
      end

      def locales
        root.join( 'config/locales' ).children
      end

      def plugins
        root.join( 'lib/git-deploy/plugins' ).children
      end

    end
  end
end
