# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'needle/version'

Gem::Specification.new do |spec|
  spec.name          = "needle"
  spec.version       = Needle::VERSION
  spec.authors       = ["Ankur Srivastava"]
  spec.email         = ["ankur.srivastava@cavisson.com"]

  spec.summary       = %q{Tool to generate automation workbench structure}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = "needle"
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~> 0.19"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
