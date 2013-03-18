require 'yaml'

module DVR
  module_function

  def []( command )
    if cmd = commands[ command ]
      return cmd[ :output ]
    else
      raise "No command recorded for `#{command}`"
    end
  end

  def commands
    @commands ||= Dir[ './spec/commands/*.yml' ].reduce( { } ) do |hsh, file|
      cmd = YAML.load_file( file )
      hsh[ cmd[ :command ] ] = cmd
      hsh
    end
  end
end

Git::Deploy::Middleware.class_eval do
  define_method( :` ){ |command| DVR[ command ] }
end
