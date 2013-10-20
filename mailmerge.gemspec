# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailmerge/version'

Gem::Specification.new do |spec|
  spec.name          = "mailmerge"
  spec.version       = Mailmerge::VERSION
  spec.authors       = ["Chad Cunningham"]
  spec.email         = ["ccunningham@innova-partners.com"]
  spec.description   = %q{Coming soon}
  spec.summary       = %q{Coming soon}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_dependency "rubyzip", "~> 1.0"
  spec.add_dependency "nokogiri"
end
