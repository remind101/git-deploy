class Git::Deploy::Middleware::Sanity
  include Git::Deploy::Middleware

  def call( env )
    remote, branch = env

    if remote.name.nil?
      raise Thor::Error,
        "There is no automatic deploy remote set up for #{branch}. " +
        "Please configure one or specify which remote to deploy to."
    end

    if !remote.exists?
      raise Thor::Error, "Remote '#{remote.name}' does not exist."
    end

    app.call env
  end
end
