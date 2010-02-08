module RDFbus
  ##
  # An RDFbus transaction.
  #
  # Transactions consist of a sequence of RDF statements to insert and a
  # sequence of RDF statements to delete from a given named graph.
  class Transaction
    include RDF::Mutable

    ##
    # RDF graph to modify when executed.
    #
    # @return [RDF::Resource]
    attr_reader :graph

    ##
    # RDF statements to insert when executed.
    #
    # @return [RDF::Enumerable]
    attr_reader :inserts

    ##
    # RDF statements to delete when executed.
    #
    # @return [RDF::Enumerable]
    attr_reader :deletes

    ##
    # Any additional options for this transaction.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    ##
    # Initializes this transaction.
    #
    # @param  [Hash{Symbol => Object}]  options
    # @option options [RDF::Resource]   :graph  (nil)
    # @option options [RDF::Enumerable] :insert ([])
    # @option options [RDF::Enumerable] :delete ([])
    # @yield  [transaction]
    # @yieldparam [Transaction] transaction
    def initialize(options = {}, &block)
      @graph   = options.delete(:graph)
      @inserts = options.delete(:insert) || RDF::Repository.new # FIXME
      @deletes = options.delete(:delete) || RDF::Repository.new # FIXME
      @options = options

      if block_given?
        case block.arity
          when 1 then block.call(self)
          else instance_eval(&block)
        end
      end
    end

    ##
    # Returns `false` to indicate that this transaction is append-only.
    #
    # Transactions do not support the `RDF::Enumerable` protocol directly.
    # To enumerate the RDF statements to be inserted or deleted, use the
    # {#inserts} and {#deletes} methods.
    #
    # @return [Boolean]
    # @see    RDF::Readable
    def readable?
      false
    end

    ##
    # Returns the JSON representation of this transaction.
    #
    # @return [Hash]
    def to_json
      require 'rdf/json' unless defined?(RDF::JSON)
      json = options.dup.to_hash rescue {}
      json.merge!({
        :graph  => graph ? graph.to_uri.to_s : nil,
        :insert => inserts.to_rdf_json,
        :delete => deletes.to_rdf_json,
      })
      json.to_json
    end

    ##
    # Appends an RDF statement to the sequence to insert when executed.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    def insert_statement(statement)
      inserts << statement
    end

    ##
    # Appends an RDF statement to the sequence to delete when executed.
    #
    # @param  [RDF::Statement] statement
    # @return [void]
    def delete_statement(statement)
      deletes << statement
    end

    undef_method :load, :update, :clear
    protected :insert_statement
    protected :delete_statement
  end
end
