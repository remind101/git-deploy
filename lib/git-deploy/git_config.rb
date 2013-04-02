class Git::Deploy::GitConfig

  def initialize( app )
    @app = app
  end

  def call( env )

    `git config --get-regexp deploy.*`.lines.each do |line|
      key, value = line.chomp.split( /\s+/, 2 )
      env[ key ] = value
    end

    # TODO this is getting to be a common pattern, DRY it up
    env[ 'git.branch' ] = `git symbolic-ref --short HEAD`
    env[ 'git.branch' ].chomp!
    env[ 'git.branch' ] = nil unless $?.success?

    env[ 'git.remote' ] = `git rev-parse --abbrev-ref --verify --quiet @{u}`
    env[ 'git.remote' ].chomp!
    env[ 'git.remote' ] = nil unless $?.success?

    @app.call env
  end
end
