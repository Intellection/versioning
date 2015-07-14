# Versioning

Adds versioning to a Rails application

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'versioning'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install versioning

## Usage

Create `config/version.txt` file with the initial version

```ruby
  0.0.1
```

rake version:bump_major                 # bump local major version
rake version:bump_minor                 # bump local minor version
rake version:bump_patch                 # bump local patch
rake version:github:bump_major          # bump local and github major versions
rake version:github:bump_minor          # bump local and github minor versions
rake version:github:bump_patch          # bump local and github patch versions
rake version:update_from_remote         # update localversion with last remote version

## Tagging releases

    $ git tag 0.0.1
    $ git push --tags
