require 'amqp'

module RDFbus
  ##
  # **`RDFbus::AMQP`** is an AMQP plugin for RDFbus.
  #
  # @example Requiring the `RDFbus::AMQP` module
  #   require 'rdfbus/amqp'
  #
  # @see http://www.amqp.org/
  # @see http://en.wikipedia.org/wiki/Advanced_Message_Queuing_Protocol
  #
  # @author [Arto Bendiken](http://ar.to/)
  module AMQP
    ##
    # AMQP transport implementation for RDFbus.
    #
    # @see RDFbus::Transport
    class Transport < RDFbus::Transport
      # TODO: to be completed for release 0.1.0
    end
  end # module AMQP
end # module RDFbus
