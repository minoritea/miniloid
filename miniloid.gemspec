# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miniloid/version'

Gem::Specification.new do |spec|
  spec.name          = "miniloid"
  spec.version       = Miniloid::VERSION
  spec.authors       = ["minoritea"]
  spec.email         = ["m.tokuda@aol.jp"]
  spec.description   = "A minimum implementation of ATOM Object model; actors; like as Celluloid."
  spec.summary       = "An actors library"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
