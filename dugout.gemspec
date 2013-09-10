# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dugout/version'

Gem::Specification.new do |spec|
  spec.name          = "dugout"
  spec.version       = Dugout::VERSION
  spec.authors       = ["Joe Fredette"]
  spec.email         = ["jfredett@gmail.com"]
  spec.description   = %q{A performance testing tool}
  spec.summary       = %q{A performance testing tool, a la minitest/benchmark, but with more robust fitting and analysis}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'katuv', '~> 0.0.6'
end

