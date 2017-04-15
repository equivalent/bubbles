module Bubbles
  class DirWatcher
    DestinationIsNotDirectory = Class.new(StandardError)

    def initialize(source_dir:, processing_dir:, command_queue:, uploader_classes:)
      @source_dir = source_dir
      @processing_dir = processing_dir
      @command_queue = command_queue
      @uploader_classes = uploader_classes
    end

    def call
      check_source_dir_existence
      check_processing_dir_existence

      source_dir_files
        .each do |file|
          bfile = BubbliciousFile.new(file: file, processing_dir: processing_dir)
          bfile.move_to_processing_dir

          uploader_classes.each do |uploader_class|
            command_queue << uploader_class.new(bfile: bfile)
          end

          command_queue << bfile.public_method(:remove_file)
        end

      command_queue << self
    end

    private
      attr_reader :processing_dir, :command_queue, :uploader_classes

      def source_dir
        Pathname.new(@source_dir)
      end

      def processing_dir
        Pathname.new(@processing_dir)
      end

      def num_of_files_to_schedule; 1 end

      def source_dir_files
        Dir
          .glob(source_dir.join('**/*').to_s)
          .last(num_of_files_to_schedule)
      end

      def check_source_dir_existence
        raise DestinationIsNotDirectory unless source_dir.directory?
      end

      def check_processing_dir_existence
        raise DestinationIsNotDirectory unless processing_dir.directory?
      end
  end
end
