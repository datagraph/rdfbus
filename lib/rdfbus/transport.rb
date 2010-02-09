module RDFbus
  ##
  # An RDFbus transport protocol.
  #
  # @abstract
  class Transport
    ##
    # The transport endpoint's URL.
    #
    # @return [RDF::URI]
    attr_reader :url

    ##
    # Returns the implementation class for the given transport name.
    #
    # @param  [Symbol] protocol
    # @return [Class]
    def self.for(protocol)
      case protocol.to_s.to_sym
        when :amqp then RDFbus::AMQP::Transport
      end
    end

    ##
    # Open a connection to a transport endpoint.
    #
    # @param  [RDF::URI]               url
    # @param  [Hash{Symbol => Object}] options
    # @yield  [transport]
    # @yieldparam [Transport] transport
    # @return [Transport]
    def self.open(url, options = {}, &block)
      protocol  = :amqp # FIXME
      transport = self.for(protocol).new(url, options)

      if !block_given?
        transport
      else
        result = block.call(transport)
        transport.close
        result
      end
    end

    ##
    # Initializes this transport.
    #
    # @param  [RDF::URI, #to_s]        url
    # @param  [Hash{Symbol => Object}] options
    def initialize(url, options = {})
      @url = case url
        when RDF::URI then url
        else RDF::URI.new(url.to_s)
      end
      open
    end

    ##
    # Opens a connection to the transport endpoint.
    #
    # @return [void]
    # @abstract
    def open() end

    ##
    # Closes the connection to the transport endpoint.
    #
    # @return [void]
    # @abstract
    def close() end

    ##
    # Transmits a transaction over the transport connection.
    #
    # @param  [Transaction]            payload
    # @param  [Hash{Symbol => Object}] options
    # @return [void]
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def publish(payload, options = {})
      raise NotImplementedError.new("#{self.class}#publish is not implemented yet")
    end

    ##
    # Receives transactions over the transport connection.
    #
    # @param  [Hash{Symbol => Object}] options
    # @yield  [payload]
    # @yieldparam [Transaction] payload
    # @return [void]
    # @raise  [NotImplementedError] unless implemented in subclass
    # @abstract
    def subscribe(options = {}, &block)
      raise NotImplementedError.new("#{self.class}#subscribe is not implemented yet")
    end

    ##
    # Returns a developer-friendly representation of this object.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(%s)>", self.class.name, object_id, url.to_s)
    end

    ##
    # Outputs a developer-friendly representation of this object to `stderr`.
    #
    # @return [void]
    def inspect!
      warn(inspect)
    end
  end
end
