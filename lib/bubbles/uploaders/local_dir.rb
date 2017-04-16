module Bubbles
  module Uploaders
    class LocalDir
      extend Forwardable

      def initialize(bfile:, command_queue:, config:)
        @bfile  = bfile
        @config = config
        @command_queue = command_queue
      end

      def call
        config.logger.debug("#{self.class.name}: transfering #{uid_file} to #{local_dir_uploader_path}")
        FileUtils.cp(uid_file, local_dir_uploader_path)
      rescue Errno::ENOENT
        command_queue.reschedule(self)
      end

      private
        attr_reader :config, :command_queue, :bfile
        def_delegators :config, :local_dir_uploader_path
        def_delegators :bfile, :uid_file
    end
  end
end
