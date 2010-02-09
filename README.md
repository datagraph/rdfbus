RDFbus
======

RDFbus is middleware for constructing RDF transactions and transmitting RDF
publish/subscribe payloads over transports such as AMQP, XMPP or Stomp.

* <http://github.com/bendiken/rdfbus>

Examples
--------

    require 'rdfbus'

### Creating a transaction for updating an RDF statement

    resource = RDF::URI.new("http://rdfbus.rubyforge.org/")

    tx = RDFbus::Transaction.new do
      delete [resource, RDF::DC.title, "RDFbus 0.0.0"]
      insert [resource, RDF::DC.title, "RDFbus 0.0.1"]
    end

### Obtaining the JSON representation of a transaction

    tx.to_json   #=> {
                 #     graph:  null,
                 #     delete: {
                 #       'http://rdfbus.rubyforge.org/': {
                 #         'http://purl.org/dc/terms/title': [
                 #           {'type': 'literal', 'value': 'RDFbus 0.0.0'}
                 #         ]
                 #       }
                 #     },
                 #     insert: {
                 #       'http://rdfbus.rubyforge.org/': {
                 #         'http://purl.org/dc/terms/title': [
                 #           {'type': 'literal', 'value': 'RDFbus 0.0.1'}
                 #         ]
                 #       }
                 #     }
                 #   }

### Executing a transaction against an RDF repository (1)

    require 'rdf/sesame'

    endpoint   = "http://localhost:8080/openrdf-sesame"
    server     = RDF::Sesame::Server.new(endpoint)
    repository = server.repository("test")

    tx = RDFbus::Transaction.new { ... }
    tx.execute(repository)

### Executing a transaction against an RDF repository (2)

    RDFbus::Transaction.execute(repository) do |tx|
      ...
    end

Documentation
-------------

* <http://rdfbus.rubyforge.org/>

### RDF Transactions

* {RDFbus::Transaction}

Dependencies
------------

* [RDF.rb](http://gemcutter.org/gems/rdf) (>= 0.0.9)
* [UUID](http://gemcutter.org/gems/uuid) (>= 2.1.1)
* [AMQP](http://gemcutter.org/gems/amqp) (>= 0.6.6)

Installation
------------

The recommended installation method is via RubyGems. To install the latest
official release from Gemcutter, do:

    % [sudo] gem install rdfbus

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/bendiken/rdfbus.git

Alternatively, you can download the latest development version as a tarball
as follows:

    % wget http://github.com/bendiken/rdfbus/tarball/master

Mailing List
------------

* <http://groups.google.com/group/rdfbus>

Resources
---------

* <http://rdfbus.rubyforge.org/>
* <http://github.com/bendiken/rdfbus>
* <http://gemcutter.org/gems/rdfbus>
* <http://rubyforge.org/projects/rdfbus/>
* <http://raa.ruby-lang.org/project/rdfbus/>
* <http://www.ohloh.net/p/rdfbus>

Author
------

* [Arto Bendiken](mailto:arto.bendiken@gmail.com) - <http://ar.to/>

License
-------

RDFbus is free and unencumbered public domain software. For more
information, see <http://unlicense.org/> or the accompanying UNLICENSE file.
