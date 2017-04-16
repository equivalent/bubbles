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
        FileUtils.cp(bfile.uid_file, local_dir_uploader_path)
      end

      private
        attr_reader :config, :command_queue, :bfile
        def_delegators :config, :local_dir_uploader_path
    end
  end
end
