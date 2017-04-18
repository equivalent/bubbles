module TestHelpers
  extend self

  def log_level
    4
  end

  def dummy_source_dir
    File.expand_path('dummy_source_dir', __dir__).to_s
  end

  def dummy_temporary_source_dir
    File.expand_path('../../tmp/dummy_temporary_source_dir', __dir__).to_s
  end

  def dummy_temporary_source_dir_init
    FileUtils.mkdir dummy_temporary_source_dir
    FileUtils.cp dummy_file_test1, dummy_temporary_source_dir
  end

  def dummy_temporary_source_dir_termination
    FileUtils.rm_rf dummy_temporary_source_dir
  end

  def dummy_config1
    File.expand_path('dummy_config1.yml', __dir__).to_s
  end

  def dummy_config2
    File.expand_path('dummy_config2.yml', __dir__).to_s
  end

  def dummy_processing_dir
    File.expand_path('../../tmp/dummy_processing_dir', __dir__).to_s
  end

  def dummy_local_dir_uploader_dir
    File.expand_path('../../tmp/dummy_local_dir_uploader_dir', __dir__).to_s
  end

  def dummy_file_test1
    Pathname.new(dummy_source_dir).join('test1.jpg').to_s
  end

  def dummy_file_test1_processing_dir
    Pathname.new(dummy_processing_dir).join('test1.jpg').to_s
  end

  def dummy_file_test2
    Pathname.new(dummy_source_dir).join('test2.png').to_s
  end

  def clean_temp_folders
    Dir
      .glob(dummy_local_dir_uploader_dir + '/**/*')
      .each { |x| FileUtils.rm(x) }
    Dir
      .glob(dummy_processing_dir + '/**/*')
      .each { |x| FileUtils.rm(x) }
  end
end
