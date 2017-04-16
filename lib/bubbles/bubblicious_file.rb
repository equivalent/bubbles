module Bubbles
  class BubbliciousFile
    extend Forwardable

    def initialize(file:, config:)
      @file   = file
      @config = config
    end

    def move_to_processing_dir
      Bubbles.logger.debug("BubbliciousFile: moving file #{file} to #{uid_file}")
      FileUtils.mv(file, uid_file)
    end

    def remove_file
      Bubbles.logger.debug("BubbliciousFile: removing file #{uid_file}")
    end

    def metadata
      { original_name: file.basename.to_s }
    end

    private
      attr_reader :config
      def_delegators :config, :uniq_filename_randomizer, :processing_dir

      def uid_file
        Pathname.new(processing_dir).join(uid_file_name)
      end

      def uid_file_name
        @uid_file_name ||= "#{uniq_filename_randomizer.call}#{file.extname}"
      end

      def file
        Pathname.new(@file)
      end
  end
end
