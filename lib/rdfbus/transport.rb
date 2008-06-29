module RDFbus
  class Transport

    attr_reader :uri

    def self.open(uri, &block)
      protocol = 'aws-sqs'
      require "rdfbus/transports/#{protocol}"

      klass = case protocol.to_sym
        when :stomp     then RDFbus::Transports::Stomp
        when :xmpp      then RDFbus::Transports::XMPP
        when :"aws-sqs" then RDFbus::Transports::AmazonSQS
      end

      transport = klass.new(uri)

      if !block_given?
        transport
      else
        result = block.call(transport)
        transport.close
        result
      end
    end

    def initialize(uri, options = {})
      @uri = uri
      open
    end

    def open() end # :nodoc:
    def close() end # :nodoc:

    def publish(payload)
      raise NotImplementedError
    end

    def subscribe(&block)
      raise NotImplementedError
    end

  end

  module Transports; end
end
