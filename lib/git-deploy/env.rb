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

      ##
      # Initializes this env. Expects the keys `remote` and `refspec` to
      # be provided.
      def initialize(*)
        super

        self[ :ref    ] = Git[ 'symbolic-ref', refspec ]
        self[ :branch ] = File.basename( ref )
        self[ :tag    ] = I18n.l Time.now, :format => :tag
        self[ :user   ] = Git[ 'config', '--global', 'user.email' ]
      end

      ##
      # Converts self to a vanilla hash suitable for passing to the i18n api.
      def to_hash
        super :symbolize_keys => true
      end

      # export ref=$(git symbolic-ref HEAD)
      # export branch=$(basename $ref)
      # export remote=$(git config deploy.$branch.remote)
      # export schema=$(git config deploy.$branch.schema)
      # export tag=$(date +'%F.%I%M%p')
      # export app=$(git config remote.$remote.url | sed 's/git@heroku.com://;s/.git//')
      # export origin=$(git config remote.origin.url | sed 's/git@github.com://;s/.git//')
      # export user=$(git config --global user.email)
      # export sha=$(git rev-parse --short HEAD)
      # export now=$(date +%s)
    end
  end
end
