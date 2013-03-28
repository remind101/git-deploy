module Git
  module Deploy
    module Utils
      class Remote

        def initialize( app )
          @app = app
        end

        def call( env )

          env[ 'remote.url' ] ||= remotes[ env[ 'remote' ] ]

          if !env[ 'remote.url' ]
            raise 'env[remote.url] is missing'
          end

          if env[ 'remote.url' ] =~ /^git@heroku\.com:/
            env[ 'remote.heroku' ] = true
          else
            env[ 'remote.heroku' ] = false
          end

          @app.call env
        end

        ##
        #
        def remotes
          `git remote -v`.lines.reduce( { } ) do |hsh, line|
            name, url, type = line.split( /\s+/ )

            hsh[ name ] = url
            hsh
          end
        end
      end
    end
  end
end
