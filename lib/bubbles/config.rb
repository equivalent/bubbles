module Bubbles
  class Config
    def self.home_config
      Pathname.new(Dir.home).join('.bubbles/config.yml').to_s
    end

    def self.var_config
      '/var/lib/bubbles/config.yml'
    end

    attr_writer :config_path, :logger, :source_dir, :processing_dir, :log_path,
      :log_level, :sleep_interval, :uploader_classes, :num_of_files_to_schedule,
      :uniq_filename_randomizer, :local_dir_uploader_path, :s3_access_key_id, :s3_secret_access_key,
      :s3_region

    def log_path
      @log_path || config_yml['log_path'] || STDOUT
    end

    def log_level
      @log_level || config_yml['log_level'] || :debug
    end

    def logger
      @logger ||= Logger.new(log_path).tap { |l| l.level = log_level }
    end

    def source_dir
      @source_dir ||= config_yml.fetch('source_dir') { raise_config_required }
      pathnamed(@source_dir)
    end

    def processing_dir
      @processing_dir ||= config_yml.fetch('processing_dir') { raise_config_required }
      pathnamed(@processing_dir)
    end

    def uploader_classes
      return @uploader_classes if @uploader_classes
      if uploaders = config_yml['uploaders']
        uploaders.map { |u| Object.const_get(u) }
      else
        [Bubbles::Uploaders::S3]
      end
    end

    def local_dir_uploader_path
      err_msg = 'As you are using LocalDir uploader,' +
        ' you need to specify `local_dir_uploader_path` in your config' +
        ' so the uploader knows where to upload'
      @local_dir_uploader_path ||= config_yml.fetch('local_dir_uploader_path') { raise err_msg }
      pathnamed(@local_dir_uploader_path)
    end

    # number of seconds between every command execution in queue seconds, defaults to 1
    def sleep_interval
      @sleep_interval || 1
    end

    # how many files should DirWatcher schedule for upload, defaults to 1
    def num_of_files_to_schedule
      @num_of_files_to_schedule || 1
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

    def uniq_filename_randomizer
      @uniq_filename_randomizer ||= ->() { SecureRandom.uuid }
    end

    def s3_credentials
      @aws_credentials ||= Aws::Credentials.new(access_key_id, secret_access_key)
    end

    private
      def s3_access_key_id
        @s3_access_key_id \
          || config_yml['s3_access_key_id'] \
          || raise('Please provide s3_access_key_id in your config file')
      end

      def s3_secret_access_key
        @s3_secret_access_key \
          || config_yml['s3_secret_access_key'] \
          || raise('Please provide s3_secret_access_key in your config file')
      end

      def s3_region
        @s3_region \
          || config_yml['s3_region'] \
          || raise('Please provide s3_region in your config file')
      end

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

      def pathnamed(location_obj)
        location_obj.respond_to?(:basename) ? location_obj :  Pathname.new(location_obj)
      end
  end
end
