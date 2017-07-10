# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_admin/audit/version'

Gem::Specification.new do |spec|
  spec.name          = 'activeadmin-audit'
  spec.version       = ActiveAdmin::Audit::VERSION
  spec.authors       = ["Alex Emelyanov"]
  spec.email         = ["aemelyanov@spbtv.com"]

  spec.summary       = 'PaperTrail based audit for ActiveAdmin'
  spec.description   = 'Allow to track changes of records which done through ActiveAdmin'
  spec.homepage      = 'https://github.com/holyketzer/activeadmin-audit'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activeadmin', '>= 1.0.0'
  spec.add_dependency 'paper_trail', '>= 5.2.3'
  spec.add_dependency 'rails', '>= 4.0.0'

  spec.add_development_dependency 'appraisal', '2.1.0'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  spec.add_development_dependency 'database_cleaner', '~> 1.5.0'
  spec.add_development_dependency 'factory_girl_rails'
  spec.add_development_dependency 'pg', '~> 0.18.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3', '>= 3.3.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.3'
  spec.add_development_dependency 'temping', '~> 3.7', '>= 3.3.0'
end
