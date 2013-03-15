shared_context 'shell', :sh => true do

  # TODO this needs to be its own gem. Think VCR for shell commands.
  before do
    subject.stub :sh do |*args|
      case args
      when [ 'git', 'push foo bar --dry-run' ] then <<-EOS
EOS
      when [ 'heroku', 'ps:scale worker=0' ] then <<-EOS
Scaling worker processes... done, now running 0
EOS
      when [ 'heroku', 'ps:scale worker=1' ] then <<-EOS
Scaling worker processes... done, now running 1
EOS
      when [ 'heroku', 'ps' ] then <<-EOS
=== web: `bundle exec [REDACTED]`
web.1: up 2013/03/14 17:25:09 (~ 21h ago)
web.2: up 2013/03/14 17:21:18 (~ 21h ago)

=== worker: `bundle exec [REDACTED]`
worker.1: up 2013/03/14 14:52:46 (~ 23h ago)
EOS
      when [ 'heroku', 'maintenance:on' ] then <<-EOS
Enabling maintenance mode for [REDACTED]... done
EOS
      when [ 'heroku', 'maintenance:off' ] then <<-EOS
Disabling maintenance mode for [REDACTED]... done
EOS
      else
        raise "Unrecognized command #{args.inspect}"
      end
    end
  end
end
