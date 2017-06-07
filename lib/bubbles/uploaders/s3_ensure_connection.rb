module Bubbles
  module Uploaders
    class S3EnsureConnection
      extend Forwardable
      include Bubbles::CommonUploaderInterface

      def call
        s3.list_buckets
      end

      def inspect
        "<##{self.class.name} testing connection to s3 bucket>"
      end

      private
        def_delegators :config, :s3_bucket, :s3_credentials, :s3_region

        def s3
          @s3 ||= Aws::S3::Client.new({
            region: s3_region,
            credentials: s3_credentials
          })
        end
    end
  end
end
