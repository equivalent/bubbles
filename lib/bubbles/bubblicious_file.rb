module Bubbles
  class BubbliciousFile
    attr_reader :randomizer

    def initialize(file:, processing_dir:, randomizer: ->(){SecureRandom.uuid})
      @file = file
      @processing_dir = processing_dir
      @randomizer = randomizer
    end

    def move_to_processing_dir
      Bubbles.logger.debug("BubbliciousFile: moving file #{file} to #{uid_file}")
    end

    def remove_file
      Bubbles.logger.debug("BubbliciousFile: removing file #{uid_file}")
    end

    def metadata
      { original_name: file.basename }
    end

    private
      def uid_file
        Pathname.new(processing_dir)
      end

      def uid_file_name
        @uid_file_name ||= "#{randomizer.call}.#{file.extname}"
      end

      def file
        Pathname.new(@file)
      end
  end
end
