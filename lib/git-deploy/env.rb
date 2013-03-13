require 'hashie/dash'

module Git
  module Deploy
    class Env < Hashie::Dash
      property :remote,  :required => true
      property :refspec, :required => true
      property :ref
      property :branch
      property :tag
      property :user
      property :sha

      ##
      # Initializes this env. Expects the keys `remote` and `refspec` to
      # be provided.
      def initialize(*)
        super

        self[ :ref    ] = Git[ 'symbolic-ref', refspec ]
        self[ :branch ] = File.basename( ref )
        self[ :tag    ] = I18n.l Time.now, :format => :tag
        self[ :user   ] = Git[ 'config', '--global', 'user.email' ]
        self[ :sha    ] = Git[ 'rev-parse', '--short', refspec ]
      end

      ##
      # Converts self to a vanilla hash suitable for passing to the i18n api.
      def to_hash
        super :symbolize_keys => true
      end
    end
  end
end
