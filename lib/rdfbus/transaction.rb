module RDFbus
  class Transaction
    attr_reader :uuid
    attr_reader :inserts
    attr_reader :deletes

    def self.parse(io)
      self.new # TODO
    end

    def initialize(uuid = nil, inserts = [], deletes = [])
      @uuid = uuid || `uuidgen`.chomp.downcase
      @inserts, @deletes = inserts, deletes
    end

    def uri
      "urn:uuid:#{uuid}"
    end

    def insert(*stmts)
      @inserts += stmts
    end

    def delete(*stmts)
      @deletes += stmts
    end

    def to_a
      # TODO
    end
  end
end
