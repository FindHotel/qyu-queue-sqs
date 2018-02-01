require 'aws-sdk-sqs'
require 'json'

module Qyu
  module Queue
    module SQS
      class Adapter < Qyu::Queue::SQS.interface
        TYPE = :sqs

        def initialize(config)
          init_client(config)
        end

        def self.valid_config?(config)
         ConfigurationValidator.new(config).valid?
        end

        def enqueue_task(queue_name, task_id)
          response = @sqs.send_message({
            queue_url: get_or_create_queue_url(queue_name),
            message_body: { task_id: task_id }.to_json.to_s
          })

          Qyu.logger.debug "SQS response: #{response}"
          Qyu.logger.info "Task enqueued with ID #{task_id} in queue #{queue_name}"

          response
        end

        def enqueue_task_to_failed_queue(queue_name, task_id)
          failed_queue_name = queue_name + '-failed'
          enqueue_task(failed_queue_name, task_id)
        end

        def fetch_next_message(queue_name)
          Qyu.logger.debug "Listening on `#{queue_name}`"

          while (response = @sqs.receive_message({
            queue_url: get_or_create_queue_url(queue_name),
            max_number_of_messages: 1
          })).messages.count == 0

          sleep 1
          end

          message = response.messages[0]

          Qyu.logger.debug "Fetched message #{message}"

          {
            'id' => message.receipt_handle,
            'task_id' => JSON.parse(message.body)['task_id']
          }
        end

        def acknowledge_message(queue_name, message_id)
          @sqs.delete_message({
            queue_url: get_or_create_queue_url(queue_name),
            receipt_handle: message_id
          })
        end

        private

        def get_or_create_queue_url(queue_name)
          full_queue_name = "#{@queue_prefix}-#{queue_name}"
          begin
            response = @sqs.get_queue_url({
              queue_name: full_queue_name
            })

            return response.queue_url
          rescue Aws::SQS::Errors::NonExistentQueue

            Qyu.logger.info "Could not find queue `#{full_queue_name}`, creating it"

            response = @sqs.create_queue({
              queue_name: full_queue_name,
              attributes: @queue_attributes
            })

            response.queue_url
          end
        end

        # noinspection RubyArgCount
        def init_client(config)

          Qyu.logger.debug "Initializing SQS client with configuration #{config}"

          @queue_prefix = config[:queue_prefix]
          @sqs = Aws::SQS::Client.new(
            region: config[:region],
            access_key_id: config[:access_key_id],
            secret_access_key: config[:secret_access_key]
          )
          @queue_attributes = queue_attributes(config)
        end

        def queue_attributes(config)
          attrs = {}
          if config[:message_visibility_timeout]
            attrs['VisibilityTimeout'] = config[:message_visibility_timeout].to_s
          end

          if config[:message_retention_period]
            attrs['MessageRetentionPeriod'] = config[:message_retention_period].to_s
          end

          if config[:maximum_message_size]
            attrs['MaximumMessageSize'] = config[:maximum_message_size].to_s
          end

          attrs
        end
      end
    end
  end
end

if defined?(Qyu::Config::MessageQueue)
  Qyu::Config::MessageQueue.register(Qyu::Queue::SQS::Adapter)
end

if defined?(Qyu::Factory::MessageQueue)
  Qyu::Factory::MessageQueue.register(Qyu::Queue::SQS::Adapter)
end
