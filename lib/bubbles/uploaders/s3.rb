module Bubbles
  module Uploaders
    class S3
      extend Forwardable
      include Bubbles::CommonUploaderInterface

      def call
        File.open(uid_file, 'rb') do |file|
          s3.put_object(bucket: s3_bucket, key: s3_full_path, body: file, acl: config.s3_acl, metadata: metadata)
        end
      rescue => e
        config.logger.error("#{e.message}")
        command_queue.reschedule(self)
      end

      def inspect
        "<##{self.class.name} uid_file: #{uid_file} to: s3://#{s3_bucket}#{s3_full_path}>"
      end

      private
        def_delegators :config, :s3_bucket, :s3_path, :s3_credentials, :s3_region
        def_delegators :bfile, :uid_file, :uid_file_name, :metadata

        def s3
          @s3 ||= Aws::S3::Client.new({
            region: s3_region,
            credentials: s3_credentials
          })
        end

        def s3_full_path
          Pathname.new(s3_path).join(uid_file_name).to_s
        end
    end
  end
end
