require 'right_aws'

module RDFbus class Transport
  ##
  # Amazon SQS/S3 transport for RDFbus.
  class AWS < Transport
    def initialize(uri, options = {})
      super

      @sqs = RightAws::SqsGen2.new(ENV['AMAZON_ACCESS_KEY_ID'], ENV['AMAZON_SECRET_ACCESS_KEY'])
      @queue = @sqs.queue(Digest::SHA1.hexdigest(uri.to_s), true)

      @s3 = RightAws::S3.new(ENV['AMAZON_ACCESS_KEY_ID'], ENV['AMAZON_SECRET_ACCESS_KEY'])
      @bucket = @s3.bucket('rdfbus') # FIXME
    end

    def publish(payload)
      payload = payload.to_s
      key = Digest::SHA1.hexdigest(payload)
      @bucket.put(key, payload)
      @queue.send_message(key)
    end

    def subscribe(interval = 2, timeout = nil, &block)
      start = Time.now
      loop do
        if msg = @queue.receive
          key = @bucket.key(msg.body)
          block.call(key.data)
          msg.delete
          key.delete
        end
        break if !timeout.nil? && (Time.now - start) >= timeout
        sleep interval
      end
    end
  end
end end
