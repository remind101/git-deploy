class Git::Deploy::GitConfig

  def initialize( app )
    @app = app
  end

  def call( env )

    `git config --list`.lines.each do |line|
      key, value = line.chomp.split( /=/, 2 )
      env[ "git.config.#{key}" ] = value
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
