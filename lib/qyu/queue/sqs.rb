require_relative "./sqs/version"

module Qyu
  module Queue
    module SQS
      autoload :Adapter,                'qyu/queue/sqs/adapter'
      autoload :ConfigurationValidator, 'qyu/queue/sqs/configuration_validator'
      autoload :Logger,                 'qyu/queue/sqs/logger'

      class << self
        def interface
          defined?(Qyu::MessageQueue::Base) ? Qyu::MessageQueue::Base : Object
        end
      end
    end
  end

  class << self
    unless defined?(logger)
      def logger=(logger)
        @@__logger = logger
      end

      def logger
        @@__logger ||= Qyu::Queue::SQS::Logger.new(STDOUT)
      end
    end
  end
end

Qyu::Config::QueueConfig.register(Qyu::Queue::SQS::Adapter) if defined?(Qyu::Config::QueueConfig)
Qyu::Factory::QueueFactory.register(Qyu::Queue::SQS::Adapter) if defined?(Qyu::Factory::QueueFactory)
