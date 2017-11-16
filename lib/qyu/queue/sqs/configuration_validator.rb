module Qyu
  module Queue
    module SQS
      class ConfigurationValidator
        VALID_REGIONS = %w(
          us-east-1 us-west-1 us-west-2 ca-central-1 ap-south-1
          ap-northeast-2 ap-southeast-1 ap-southeast-2
          ap-northeast-1 eu-central-1 eu-west-1 eu-west-2
          sa-east-1
        ).freeze

        attr_reader :errors

        def initialize(config)
          @config = config
          @errors = []
        end

        def valid?
          validate
          @errors.empty?
        end

        def validate
          validate_aws_region
          validate_aws_access_key_id
          validate_aws_secret_access_key
          validate_queue_prefix
          validate_message_visibility_timeout
          validate_message_retention_period
          validate_maximum_message_size
        end

        private

        def validate_queue_prefix
          unless @config[:queue_prefix]
            @errors << 'queue_prefix must be present.'
          end
        end

        def validate_aws_region
          unless @config[:region].present?
            @errors << 'AWS region must be present.'
            return
          end

          unless VALID_REGIONS.include?(@config[:region])
            @errors << 'AWS region invalid.'
          end
        end

        def validate_aws_access_key_id
          if @config[:access_key_id].nil? || @config[:access_key_id].blank?
            @errors << 'AWS access_key_id must be present.'
          end
        end

        def validate_aws_secret_access_key
          if @config[:secret_access_key].nil? || @config[:secret_access_key].blank?
            @errors << 'AWS secret_access_key must be present.'
          end
        end

        def validate_message_visibility_timeout
          return unless @config[:message_visibility_timeout]
          if @config[:message_visibility_timeout].to_i < 0 ||
            @config[:message_visibility_timeout].to_i > 43_200
            @errors << 'message_visibility_timeout should be between 0 and 43,200 seconds'
          end
        end

        def validate_message_retention_period
          return unless @config[:message_retention_period]
          if @config[:message_retention_period].to_i < 60 ||
            @config[:message_retention_period].to_i > 1_209_600
            @errors << 'message_retention_period should be between 60 and 1,209,600 seconds'
          end
        end

        def validate_maximum_message_size
          return unless @config[:maximum_message_size]
          if @config[:maximum_message_size].to_i < 1_024 ||
            @config[:maximum_message_size].to_i > 262_144
            @errors << 'maximum_message_size should be between 1,024 and 262,144 bytes'
          end
        end

      end
    end
  end
end
