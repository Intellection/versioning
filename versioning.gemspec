# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'versioning/version_tag'

Gem::Specification.new do |spec|
  spec.name          = "versioning"
  spec.version       = Versioning::VERSION
  spec.authors       = ["Daniela"]
  spec.email         = ["daniela@zappistore.com"]
  spec.summary       = %q{Versioning}
  spec.description   = %q{}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "slack-notifier", "~> 1.0"
end
