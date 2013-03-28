class Git::Deploy::GitConfig

  def initialize( app )
    @app = app
  end

  def call( env )

    `git config --get-regexp deploy.*`.lines.each do |line|
      key, value = line.chomp.split( /\s+/, 2 )
      env[ key ] = value
    end

    @app.call env
  end
end
