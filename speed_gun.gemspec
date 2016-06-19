# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'speed_gun/version'

Gem::Specification.new do |spec|
  spec.name          = 'speed_gun'
  spec.version       = SpeedGun::VERSION
  spec.authors       = ['Sho Kusano']
  spec.email         = ['sho-kusano@zeny.io']

  spec.summary       = 'Better web app profiler for Rails apps'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/zeny-io/speed_gun'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'semantic'
  spec.add_dependency 'rblineprof'
  spec.add_dependency 'rack'
  spec.add_dependency 'msgpack'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'yard'
end
