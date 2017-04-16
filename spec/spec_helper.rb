require "bundler/setup"
require "bubbles"
require 'support/test_helpers'
require 'irb' # for binding.irb debugging

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    TestHelpers.clean_temp_folders
  end

  config.after(:each) do
    TestHelpers.clean_temp_folders
  end
end

RSpec.shared_context 'common uploader initialization' do
  subject { described_class.new(config: config, bfile: bfile, command_queue: command_queue) }
end

RSpec.shared_context 'common uploader command_queue setup' do
  let(:command_queue) do
    Bubbles::CommandQueue
      .new(config: config)
      .tap { |x| x << :already_existing_one }
  end
end

RSpec.shared_context 'successful uploader file transfer preparation' do
  let(:uid_file) do
    FileUtils.cp(TestHelpers.dummy_file_test1, TestHelpers.dummy_file_test1_processing_dir)
    TestHelpers.dummy_file_test1_processing_dir
  end
end

RSpec.shared_examples 'uploader that keeps file in processing direcory' do
  it 'keeps the file in processing directory after operation' do
    expect(File.exist?(uid_file)).to be true
    trigger
    expect(File.exist?(uid_file)).to be true
  end
end
