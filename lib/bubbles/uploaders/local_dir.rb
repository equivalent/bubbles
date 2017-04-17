module Bubbles
  module Uploaders
    class LocalDir
      extend Forwardable
      include Bubbles::CommonUploaderInterface

      def call
        config.logger.debug("#{self.class.name}: transfering #{uid_file} to #{local_dir_uploader_path}")
        FileUtils.cp(uid_file, local_dir_uploader_path)
      rescue Errno::ENOENT => e
        config.logger.error("#{e.message}")
        command_queue.reschedule(self)
      end

      private
        def_delegators :config, :local_dir_uploader_path
        def_delegators :bfile, :uid_file
    end
  end
end
