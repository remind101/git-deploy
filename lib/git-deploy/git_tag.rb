class Git::Deploy::GitTag
  include Git::Deploy::Shell

  def self.configure( opts )
    opts.on :T, :tag, 'Tag the deployment.'
  end

  def initialize( app, options )
    @app, @options = app, options

    # "2013-04-12.1132AM"
    @options[ :tagname ] ||= '%F.%I%M%p'
    # "Release: Friday, April 12, 2013 11:35:12 AM PDT"
    @options[ :message ] ||= 'Release: %A, %B %d, %Y %r %Z'
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
