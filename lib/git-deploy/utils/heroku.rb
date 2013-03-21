module Git
  module Deploy
    module Utils
      class Heroku

        def initialize( env )
          @options, @remote, @branch, @args = env
        end

        def maintenance_on
          `heroku maintenance:on --remote #{@remote}`
        end

        def maintenance_off
          `heroku maintenance:off --remote #{@remote}`
        end

        def ps
          output = `heroku ps --remote #{@remote}`
          output.lines.inject( Hash.new( 0 ) ) do |hsh, line|
            hsh[ $1 ] += 1 if line =~ /^(\w+)\.\d/
            hsh
          end
        end

        def ps_scale( hsh={} )
          spec = hsh.map { |k, v| "#{k}=#{v}" }.join ' '
          `heroku ps:scale #{spec} --remote #{@remote}`
        end

        def run( command )
          `heroku run #{command} --remote #{@remote}`
        end

      end
    end
  end
end