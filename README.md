[![Gem Version](https://badge.fury.io/rb/activeadmin-audit.svg)](https://badge.fury.io/rb/activeadmin-audit)
[![Build Status](https://travis-ci.org/holyketzer/activeadmin-audit.svg?branch=master)](https://travis-ci.org/holyketzer/activeadmin-audit)
[![Code Climate](https://codeclimate.com/github/holyketzer/activeadmin-audit/badges/gpa.svg)](https://codeclimate.com/github/holyketzer/activeadmin-audit)
[![Test Coverage](https://codeclimate.com/github/holyketzer/activeadmin-audit/badges/coverage.svg)](https://codeclimate.com/github/holyketzer/activeadmin-audit/coverage)

# Activeadmin::Audit

This gem allows you to track changes of records which done through ActiveAdmin panel. Also works with has_many relations

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activeadmin-audit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activeadmin-audit

## Setting up Active Admin Audit (for Rails)

After installing the gem, you need to run the generator. Here are your options:

- If you want to use an existing user class, provide it as an argument:
  ```sh
  rails g active_admin_audit:install User
  ```

- Otherwise, with no arguments we will create an `AdminUser` class to use with Devise:
  ```sh
  rails g active_admin_audit:install
  ```

The generator adds these core files, among others:

```
config/initializers/active_admin_audit.rb
```

Then you have to install migrations to persist papper trails:

```
rake active_admin_audit:install:migrations
```

## Usage

Copy and apply migrations

```bash
rake active_admin_audit:install:migrations
rake db:migrate
```

Include this line in your CSS code (active_admin.scss)

```scss
@import "activeadmin-audit";
```

Include this module in your `ApplicationController`

```ruby
class ApplicationController < ActionController::Base
  include ActiveAdmin::Audit::ControllerHelper
end
```

From model that you want to auditing call `has_versions` method

```ruby
class Movie < ActiveRecord::Base
  has_many :genres
  has_many :images

  has_versions skip: [:comment], also_include: {
    genres: [:id],
    images: [:url, :width, :height, :kind],
  }
```

By default `has_versions` take care about all record attributes including belongs_to references. If you don't want to include some attribute you can pass it name to `skip` options. If you want to include has_many relation pass it's name with attributes to  `also_include` option.

To display table with latest changes on the ActiveAdmin resource page use helper `latest_versions`:

```ruby
ActiveAdmin.register Movie do
  # ...

  show do |movie|
    # ...
    latest_versions(movie)
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

We test this gem against different versions of `ActiveAdmin` using [appraisal](https://github.com/thoughtbot/appraisal) gem.
To regenerate gemfiles run:

    $ appraisal install

To run specs against all versions:

    $ appraisal rake spec

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/activeadmin-audit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
