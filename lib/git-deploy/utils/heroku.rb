module Git
  module Deploy
    module Utils
      class Heroku

        def initialize( env ) # :nodoc:
          @options, @remote, @branch, *@args = env
        end

        ##
        # Enables maintenance mode for `@remote`.
        def maintenance_on
          Shell[ "heroku maintenance:on --remote #{@remote}" ]
        end

        ##
        # Disables maintenance mode for `@remote`.
        def maintenance_off
          Shell[ "heroku maintenance:off --remote #{@remote}" ]
        end

        ##
        # Retrieves the list of currently running processes as a hash,
        # keyed on process type.
        def ps
          output = Shell[ "heroku ps --remote #{@remote}" ]
          output.lines.reduce( Hash.new { |h, k| h[k] = [ ] } ) do |hsh, line|
            hsh[ $1.to_sym ] << line.chomp if line =~ /^(\w+)\.\d/
            hsh
          end
        end

        ##
        # Scales the given process types.
        def ps_scale( hsh={} )
          types = hsh.map { |k, v| "#{k}=#{v}" }.join ' '
          Shell[ "heroku ps:scale #{types} --remote #{@remote}" ]
        end

        ##
        # Runs the given shell command on `@remote`.
        def run( command )
          Shell[ "heroku run #{command} --remote #{@remote}" ]
        end
      end
    end
  end
end
