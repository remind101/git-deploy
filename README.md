# Git::Deploy

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'git-deploy'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-deploy

## Usage

First, set up your remote tracking branches to heroku:

If we have two heroku remotes, `staging` and `production`, and we want our
branches `develop` and `master` to track to those respectively:

``` sh
git branch -u staging/master develop
git branch -u production/master master
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
