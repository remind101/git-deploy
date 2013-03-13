module Git
  module Deploy
    class Env < Struct.new( :remote, :refspec )

      def ref
        @ref ||= Git[ 'symbolic-ref', refspec ]
      end

      def branch
        @branch ||= File.basename ref
      end

      def tag
        # TODO use I18n for this format
        @tag ||= Time.now.strftime '%F.%I%M%p'
      end

      def user
        @user ||= Git[ 'config', '--global', 'user.email' ]
      end

      def to_hash
        %w| remote refspec ref branch tag user |.reduce( { } ) do |hsh, key|
          hsh[ key.to_sym ] = send( key )
          hsh
        end
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
