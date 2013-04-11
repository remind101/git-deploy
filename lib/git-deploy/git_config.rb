class Git::Deploy::GitConfig

  def initialize( app )
    @app = app
  end

  def call( env )

    `git config --list`.lines.each do |line|
      key, value = line.chomp.split( /=/, 2 )
      env[ "git.config.#{key}" ] = value
    end

    set( env, 'git.branch', 'git symbolic-ref --short HEAD' )
    set( env, 'git.remote', 'git rev-parse --abbrev-ref --verify --quiet @{u}' )

    @app.call env
  end

private

  def set( env, setting, command )
    env[ setting ] = `#{command}`
    env[ setting ].chomp!
    env[ setting ] = nil unless $?.success?
  end

end
