#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdfbus'
  gem.homepage           = 'http://rdfbus.rubyforge.org/'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'Middleware for transmitting RDF publish/subscribe payloads over AMQP.'
  gem.description        = 'RDFbus is middleware for transmitting RDF publish/subscribe payloads over AMQP.'
  gem.rubyforge_project  = 'rdfbus'

  gem.authors            = ['Datagraph']
  gem.email              = 'rdfbus@googlegroups.com'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS README UNLICENSE VERSION bin/rdfbus) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w(rdfbus)
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 1.8.2'
  gem.requirements               = []
  gem.add_development_dependency 'rdf-spec', '>= 0.1.0'
  gem.add_development_dependency 'rspec',    '>= 1.3.0'
  gem.add_development_dependency 'yard' ,    '>= 0.5.3'
  gem.add_runtime_dependency     'rdf',      '>= 0.1.2'
  gem.add_runtime_dependency     'uuid',     '>= 2.2.0'
  gem.add_runtime_dependency     'amqp',     '>= 0.6.7'
  gem.post_install_message       = nil
end
