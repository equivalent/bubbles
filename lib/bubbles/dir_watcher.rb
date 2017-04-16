module Bubbles
  class DirWatcher
    extend Forwardable
    DestinationIsNotDirectory = Class.new(StandardError)

    def initialize(config:, command_queue:)
      @config        = config
      @command_queue = command_queue
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

    def inspect
      "#<#{self.class.name} source_dir: #{source_dir}, processing_dir: #{processing_dir}>"
    end

    private
      attr_reader :command_queue, :config
      def_delegators :config, :source_dir, :processing_dir, :num_of_files_to_schedule, :uploader_classes

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
