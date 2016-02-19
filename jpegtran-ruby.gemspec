# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jpegtran/version"

Gem::Specification.new do |spec|
  spec.name          = "jpegtran-ruby"
  spec.version       = Jpegtran::VERSION
  spec.authors       = ["Martin Poljak", "DM"]
  spec.email         = ["deemox@gmail.com"]

  spec.summary       = "Ruby interface to jpegtran tool"
  spec.description   = "Jpegtran provides Ruby interface to the jpegtran tool"
  spec.homepage      = "https://github.com/dimko/jpegtran-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake",    "~> 10.0"
  spec.add_development_dependency "pry"
end
