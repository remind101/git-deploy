class Git::Deploy::GitPush

  def self.configure( opts )
    opts.on :f, :force, 'Set the --force flag during the `git push`.'
  end

  def initialize( app )
    @app = app
  end

  ##
  # Pretty much the most important thing.
  def call( env )

    flags = ''
    flags << ' --force' if env[ 'options.force' ]

    `git push #{env[ 'remote' ]} #{env[ 'branch' ]}#{flags}`

    if !$?.success?
      raise Interrupt, 'git push failed'
    end

    @app.call env
  end
end
