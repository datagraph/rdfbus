require 'digest/sha1'
require 'uuid'
require 'rdf'
require 'rdfbus/version'

##
module RDFbus
  autoload :Transaction, 'rdfbus/transaction'
  autoload :Transport,   'rdfbus/transport'

  # RDFbus transports
  autoload :AMQP,        'rdfbus/amqp'
end
