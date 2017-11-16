require_relative "./sqs/version"

module Qyu
  module Queue
    module SQS
      autoload :Adapter,                'qyu/queue/sqs/adapter'
      autoload :ConfigurationValidator, 'qyu/queue/sqs/configuration_validator'
      autoload :Logger,                 'qyu/queue/sqs/logger'

      class << self
        def interface
          defined?(ArcYu::MessageQueue::Base) ? ArcYu::MessageQueue::Base : Object
        end
      end
    end
  end
end
