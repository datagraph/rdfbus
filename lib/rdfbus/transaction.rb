module RDFbus
  class Transaction
    include RDF
    RDF = Namespace[:rdf]
    CS  = Namespace.new('http://purl.org/vocab/changeset/schema#')

    attr_reader   :uuid, :inserts, :deletes
    attr_accessor :date, :creator, :description

    def self.parse(io)
      self.new # TODO
    end

    def initialize(uuid = nil, inserts = [], deletes = [])
      @uuid = uuid || `uuidgen`.chomp.downcase
      @inserts, @deletes = inserts, deletes
    end

    def uri
      @uri ||= "urn:uuid:#{uuid}"
    end

    def insert(*stmts)
      @inserts += stmts
      self
    end

    def delete(*stmts)
      @deletes += stmts
      self
    end

    def inserts_reified
      stmts = []
      inserts.each do |s, p, o|
        bnode = Node.new
        stmts << [to_uri, CS[:addition], bnode]
        stmts << [bnode, RDF[:type], RDF[:Statement]]
        stmts << [bnode, RDF[:subject], s]
        stmts << [bnode, RDF[:predicate], p]
        stmts << [bnode, RDF[:object], o]
      end
      stmts
    end

    def deletes_reified
      stmts = []
      deletes.each do |s, p, o|
        bnode = Node.new
        stmts << [to_uri, CS[:removal], bnode]
        stmts << [bnode, RDF[:type], RDF[:Statement]]
        stmts << [bnode, RDF[:subject], s]
        stmts << [bnode, RDF[:predicate], p]
        stmts << [bnode, RDF[:object], o]
      end
      stmts
    end

    def to_uri
      @uriref ||= URIRef.new(uri)
    end

    def to_a
      stmts = []
      stmts << [to_uri, RDF[:type], CS[:ChangeSet]]
      stmts << [to_uri, CS[:createdDate], self.date ||= Time.now.to_i]
      stmts << [to_uri, CS[:creatorName], self.creator] if self.creator
      stmts << [to_uri, CS[:changeReason], self.description] if self.description
      stmts += deletes_reified
      stmts += inserts_reified
      stmts
    end

    def to_s(options = {})
      Writer.for(options[:format] || :ntriples).buffer do |out|
        to_a.each { |triple| out << triple }
      end
    end
  end
end
