## Jpegtran

Provides Ruby interface to the [jpegtran](http://linux.die.net/man/1/jpegtran) tool.

![Travis CI](https://travis-ci.org/dimko/jpegtran-ruby.svg)

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'jpegtran-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jpegtran-ruby

This gem uses `jpegtran` executable. So it needs to be installed on the machine.  
Usually it comes with the [libjpeg](http://libjpeg.sourceforge.net) or you can use [MozJPEG](https://github.com/mozilla/mozjpeg).

### Usage

```ruby
require "jpegtran"

Jpegtran.configured? # will return true (or false)

options = { progressive: true, optimize: true }
Jpegtran.optimize("foo.jpg", options) # will run `jpegtran -progressive -optimize -outfile foo.jpg foo.jpg`
```

Note that `-maxmemory N` option isn't supported.

### Configuring

```ruby
Jpegtran.configure do |config|
  config.executable = "/usr/local/bin/jpegtran"
end
```

### Copyright

Copyright &copy; 2011 &ndash; 2016 [Martin Poljak](http://www.martinpoljak.net)
