require 'digest/sha1'
require 'right_aws'

module RDFbus::Transports
  class AmazonSQS < RDFbus::Transport

    def initialize(uri, options = {})
      super
      @conn = RightAws::SqsGen2.new(ENV['AMAZON_ACCESS_KEY_ID'], ENV['AMAZON_SECRET_ACCESS_KEY'])
      @queue = @conn.queue(Digest::SHA1.hexdigest(uri.to_s), true)
    end

    def publish(payload)
      @queue.send_message(payload.to_s)
    end

    def subscribe(interval = 2, timeout = nil, &block)
      start = Time.now
      loop do
        if msg = @queue.receive
          block.call(msg.body)
          msg.delete
        end
        sleep interval
        break if !timeout.nil? && (Time.now - start) >= timeout
      end
    end
  end
end
