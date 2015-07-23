# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ebay_webshop_connector/version'

Gem::Specification.new do |spec|
  spec.name          = "ebay_webshop_connector"
  spec.version       = EbayWebshopConnector::VERSION
  spec.authors       = ["Martin Eismann"]
  spec.email         = ["'softwerk' and then you add an @, which is subsequently followed by 'eismann.cc'"]

  spec.summary       = %q{A gem to publish your webshop's products on Ebay and receive notifications upon their being sold}
  spec.description   = %q{A gem to publish your webshop's products on Ebay and receive notifications upon their being sold}
  spec.homepage      = "https://github.com/meismann/ebay_webshop_connector"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'ebayr'
  spec.add_dependency 'activesupport'
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
