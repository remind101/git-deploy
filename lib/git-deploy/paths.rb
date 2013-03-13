require 'pathname'

module Git
  module Deploy
    class Paths < Struct.new( :base )

      ##
      # The git-deploy root directory. Assumes `base` is git-deploy.rb.
      def root
        Pathname.new( base ).dirname.dirname
      end

      ##
      # The list of localization files.
      def locales
        root.join( 'config/locales' ).children
      end

      ##
      # The list of plugin files.
      def plugins
        root.join( 'lib/git-deploy/plugins' ).children
      end
    end
  end
end
