module RDFbus
  ##
  # An RDFbus transaction.
  #
  # Transactions consist of a sequence of RDF statements to insert and a
  # sequence of RDF statements to delete from a given named graph.
  class Transaction
    include RDF::Mutable

    ##
    # Executes a transaction against the given RDF repository.
    #
    # @param  [RDF::Repository]         repository
    # @param  [Hash{Symbol => Object}]  options
    # @yield  [transaction]
    # @yieldparam [Transaction] transaction
    # @return [void]
    def self.execute(repository, options = {}, &block)
      self.new(&block).execute(repository, options)
    end

    ##
    # RDF graph to modify when executed.
    #
    # @return [RDF::Resource]
    attr_reader :graph

    ##
    # RDF statements to delete when executed.
    #
    # @return [RDF::Enumerable]
    attr_reader :deletes

    ##
    # RDF statements to insert when executed.
    #
    # @return [RDF::Enumerable]
    attr_reader :inserts

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
    # Executes this transaction against the given RDF repository.
    #
    # @param  [RDF::Repository]         repository
    # @param  [Hash{Symbol => Object}]  options
    # @return [void]
    def execute(repository, options = {})
      before_execute(repository, options) if respond_to?(:before_execute)

      deletes.each_statement do |statement|
        statement = statement.dup
        statement.context = graph
        repository.delete(statement)
      end

      inserts.each_statement do |statement|
        statement = statement.dup
        statement.context = graph
        repository.insert(statement)
      end

      after_execute(repository, options) if respond_to?(:after_execute)
      nil
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
        :delete => deletes.to_rdf_json,
        :insert => inserts.to_rdf_json,
      })
      json.to_json
    end

    ##
    # Returns a developer-friendly representation of this transaction.
    #
    # @return [String]
    def inspect
      sprintf("#<%s:%#0x(graph: %s, deletes: %d, inserts: %d)>", self.class.name, object_id,
        graph ? graph.to_s : 'nil', deletes.count, inserts.count)
    end

    ##
    # Outputs a developer-friendly representation of this transaction to
    # `stderr`.
    #
    # @return [void]
    def inspect!
      warn(inspect)
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
