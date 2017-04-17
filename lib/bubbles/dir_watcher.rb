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
        .last(num_of_files_to_schedule)
        .each do |file|
          bfile = BubbliciousFile.new(file: file, config: config)
          bfile.move_to_processing_dir

          uploader_classes.each do |uploader_class|
            command_queue << uploader_class.new(bfile: bfile, command_queue: command_queue, config: config)
          end

          command_queue << bfile.public_method(:remove_file)
        end

      command_queue << self
    end

    def inspect
      "#<#{self.class.name} source_dir: #{source_dir}, processing_dir: #{processing_dir}>"
    end

    def source_dir_files
      Dir
        .glob(source_dir.join('**/*').to_s)
        .select { |x| Pathname.new(x).file? }
    end

    private
      attr_reader :command_queue, :config
      def_delegators :config, :source_dir, :processing_dir, :num_of_files_to_schedule, :uploader_classes

      def check_source_dir_existence
        raise DestinationIsNotDirectory unless source_dir.directory?
      end

      def check_processing_dir_existence
        raise DestinationIsNotDirectory unless processing_dir.directory?
      end
  end
end
