class Git::Deploy::GitPush

  def initialize( app )
    @app = app
  end

  ##
  # Pretty much the most important thing.
  def call( env )

    `git push #{env[ 'remote' ]} #{env[ 'branch' ]}`

    if !$?.success?
      raise Interrupt, 'git push failed'
    end

    @app.call env
  end
end
