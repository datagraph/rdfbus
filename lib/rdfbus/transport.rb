module RDFbus
  ##
  # An RDFbus transport protocol.
  #
  # @abstract
  class Transport
    autoload :AMQP,  'rdfbus/transport/amqp'
    autoload :AWS,   'rdfbus/transport/aws'
    autoload :Stomp, 'rdfbus/transport/stomp'
    autoload :XMPP,  'rdfbus/transport/xmpp'

    # @return [URI]
    attr_reader :uri

    ##
    # @param  [Symbol] protocol
    # @return [Transport]
    def self.for(protocol)
      case protocol.to_s.to_sym
        when :amqp  then RDFbus::Transport::AMQP
        when :aws   then RDFbus::Transport::AWS
        when :stomp then RDFbus::Transport::Stomp
        when :xmpp  then RDFbus::Transport::XMPP
      end
    end

    ##
    # @param  [URI] uri
    # @yield  [transport]
    # @yieldparam [Transport]
    # @return [Transport]
    def self.open(uri, &block)
      protocol  = :amqp # FIXME
      transport = self.for(protocol).new(uri)

      if !block_given?
        transport
      else
        result = block.call(transport)
        transport.close
        result
      end
    end

    ##
    # @param  [URI] uri
    def initialize(uri, options = {})
      @uri = case uri
        when RDF::URI then uri
        else RDF::URI.new(uri.to_s)
      end
      open
    end

    ##
    # @abstract
    def open() end

    ##
    # @abstract
    def close() end

    ##
    # @raise [NotImplementedError] unless implemented in subclass
    # @abstract
    def publish(payload)
      raise NotImplementedError
    end

    ##
    # @raise [NotImplementedError] unless implemented in subclass
    # @abstract
    def subscribe(&block)
      raise NotImplementedError
    end

  end
end
