module Bubbles
  class Config
    def self.home_config
      Pathname.new(Dir.home).join('.bubbles/config.yml').to_s
    end

    def self.var_config
      '/var/lib/bubbles/config.yml'
    end

    attr_writer :config_path

    def log_path
      config_yml['log_path'] || STDOUT
    end

    def log_level
      config_yml['log_level'] || :debug
    end

    def logger
      @logger ||= Logger.new(log_path).tap { |l| l.level = log_level }
    end

    def source_dir
      Pathname.new(config_yml.fetch('source_dir') { raise_config_required })
    end

    def processing_dir
      Pathname.new(config_yml.fetch('processing_dir') { raise_config_required })
    end

    def uploader_classes
      if uploaders = config_yml['uploaders']
        uploaders.map { |u| Object.const_get(u) }
      else
        [Bubbles::Uploaders::S3]
      end
    end

    def sleep_interval
      1 # seconds
    end

    def config_path
      if @config_path
        raise "Config file #{@config_path} does not exist" unless File.exist?(@config_path)
        @config_path
      elsif File.exist?(self.class.var_config)
        self.class.var_config
      elsif File.exist?(self.class.home_config)
        self.class.home_config
      end
    end

    private
      def config_yml
        if config_path
          @config_yml ||= YAML.load_file(config_path)
        else
          {}
        end
      end

      def raise_config_required
        raise "Please provide configuration file. You can do this by creating #{self.class.home_config} or check project github README.md"
      end
  end
end
