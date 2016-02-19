## Jpegtran

Provides Ruby interface to the [jpegtran](http://linux.die.net/man/1/jpegtran) tool.

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'jpegtran-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jpegtran-ruby

### Usage

```ruby
require "jpegtran"

Jpegtran.configured? # will return true (or false)

options = { progressive: true, optimize: true }
Jpegtran.optimize("foo.jpg", options)

# will run 'jpegtran -progressive -optimize -outfile foo.jpg foo.jpg'
```

Configuration:

```ruby
Jpegtran.configure do |config|
  config.executable = "/usr/local/bin/jpegtran"
end
```

The `-maxmemory N` option isn't supported.

### Copyright

Copyright &copy; 2011 &ndash; 2016 [Martin Poljak](http://www.martinpoljak.net).
See `LICENSE.txt` for further details.
