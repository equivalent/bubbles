module Bubbles
  class Config
    attr_writer :log_path

    def log_path
      @log_path
    end

    def logger
      Logger.new(log_path || STDOUT)
    end

    def source_dir
      '/tmp/foo'
    end

    def processing_dir
      '/tmp/bar'
    end

    def uploader_classes
      []
    end

    def sleep_interval
      1 # seconds
    end
  end
end
