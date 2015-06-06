# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'name_sort/version'

Gem::Specification.new do |spec|
  spec.name          = "name_sort"
  spec.version       = NameSort::VERSION
  spec.authors       = ["Matthew Jording"]
  spec.email         = ["mjording@gmail.com"]

  spec.summary       = %q{Quick demo for gem creation and delimited file sorting}
  spec.description   = %q{Quick demo for gem creation and delimited file sorting}
  spec.homepage      = "https://github.com/mjording/name_sort"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'pry', '~> 0.10.1'
  spec.add_development_dependency 'awesome_print', '~> 1.6.1'
end
