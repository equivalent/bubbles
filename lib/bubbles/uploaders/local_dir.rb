module Bubbles
  module Uploaders
    class LocalDir
      extend Forwardable
      include Bubbles::CommonUploaderInterface

      def call
        config.logger.debug("#{self.class.name}: transfering #{uid_file} to #{local_dir_uploader_path}")
        FileUtils.cp(uid_file, local_dir_uploader_path)
        write_metadata
      rescue Errno::ENOENT => e
        config.logger.error("#{e.message}")
        command_queue.reschedule(self)
      end

      def inspect
        "<##{self.class.name} uid_file: #{uid_file} to: #{local_dir_uploader_path}>"
      end

      private
        def_delegators :config, :local_dir_uploader_path, :local_dir_metadata_file_path
        def_delegators :bfile, :uid_file, :uid_file_name, :metadata

        def write_metadata
          File.open(local_dir_metadata_file_path, 'a') do |f|
            f.write yaml_append
          end
        end

        def yaml_append
<<EOF
-
  key: #{uid_file_name}
  path: #{uid_file}
  metadata: #{metadata.to_json}
EOF
        end
    end
  end
end
