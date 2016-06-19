# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'yard'
require 'yard/rake/yardoc_task'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = []
  t.options.push('--debug', '--verbose') if $trace
end

task default: :spec
