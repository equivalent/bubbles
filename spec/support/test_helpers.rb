module TestHelpers
  extend self

  def dummy_source_dir
    File.expand_path('dummy_source_dir', __dir__).to_s
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

  def dummy_file_test1
    Pathname.new(dummy_source_dir).join('test1.jpg').to_s
  end

  def dummy_file_test2
    Pathname.new(dummy_source_dir).join('test2.png').to_s
  end
end
