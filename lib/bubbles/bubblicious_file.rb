module Bubbles
  class BubbliciousFile
    extend Forwardable

    def initialize(file:, config:)
      @file   = file
      @config = config
    end

    def copy_to_processing_dir
      config.logger.debug("BubbliciousFile: copy file #{file} to #{uid_file}")
      FileUtils.cp(file, uid_file)
    end

    def remove_file
      config.logger.debug("BubbliciousFile: removing file #{uid_file}")
      FileUtils.rm(uid_file)
      config.logger.debug("BubbliciousFile: removing file #{file}")
      FileUtils.rm(file)
    end

    def metadata
      { original_name: file.basename.to_s }
    end

    def uid_file
      Pathname.new(processing_dir).join(uid_file_name)
    end

    def uid_file_name
      @uid_file_name ||= "#{uniq_filename_randomizer.call}#{file.extname}"
    end

    private
      attr_reader :config
      def_delegators :config, :uniq_filename_randomizer, :processing_dir

      def file
        Pathname.new(@file)
      end
  end
end
