class Git::Deploy::GitTag
  include Git::Deploy::Shell

  def self.configure( opts )
    opts.on :T, :tag, 'Tag the deployment.'
  end

  def initialize( app, options )
    @app, @options = app, options
  end

  def call( env )
    if env[ 'options.tag' ]

      now = DateTime.now
      tag = now.strftime @options[ :tagname ]
      msg = now.strftime @options[ :message ]

      sh 'git tag "%s" -m "%s"' % [ tag, msg ]
      sh 'git push origin --tags'
    end

    @app.call env
  end
end
