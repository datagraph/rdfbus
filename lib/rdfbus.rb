require 'digest/sha1'
require 'uuidtools'
require 'rdf'
require 'rdfbus/version'

module RDFbus
  autoload :Transaction, 'rdfbus/transaction'
  autoload :Transport,   'rdfbus/transport'
end
