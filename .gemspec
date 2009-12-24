#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

GEMSPEC = Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdfbus'
  gem.homepage           = 'http://github.com/bendiken/rdfbus' # FIXME
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'Middleware for transmitting RDF publish/subscribe payloads over AMQP.'
  gem.description        = 'RDFbus is middleware for transmitting RDF publish/subscribe payloads over AMQP.'
  gem.rubyforge_project  = 'rdfbus'

  gem.authors            = ['Arto Bendiken']
  gem.email              = 'arto.bendiken@gmail.com'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS README UNLICENSE VERSION) # TODO
  gem.bindir             = %q(bin)
  gem.executables        = %w() # TODO
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 1.8.2'
  gem.requirements               = []
  gem.add_development_dependency 'rspec', '>= 1.2.9'
  gem.add_runtime_dependency     'rdf',   '>= 0.0.4'
  gem.add_runtime_dependency     'amqp',  '>= 0.6.5'
  gem.post_install_message       = nil
end
