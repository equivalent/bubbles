require 'spec_helper'
describe 'full cycle' do
  let(:config) do
    Bubbles::Config.new.tap do |c|
      c.use_default_config_locations = false
      c.log_level = TestHelpers.log_level
      c.source_dir = TestHelpers.dummy_temporary_source_dir
      c.processing_dir = TestHelpers.dummy_processing_dir
      c.uploader_classes = [Bubbles::Uploaders::S3, Bubbles::Uploaders::LocalDir]
      c.local_dir_uploader_path = TestHelpers.dummy_local_dir_uploader_dir
      c.local_dir_metadata_file_path = TestHelpers.dummy_local_dir_metadata_file_path
      c.s3_region = 'eu-west-1'
      c.s3_bucket = 'mybckt'
      c.s3_access_key_id     = 'xxxxxxxxxxx'
      c.s3_secret_access_key = 'yyyyyyyyyyy'
    end
  end

  let(:command_queue) { Bubbles::CommandQueue.new config: config }
  let(:dir_watcher)   { Bubbles::DirWatcher.new command_queue: command_queue, config: config }

  before do
    TestHelpers.dummy_temporary_source_dir_init
    command_queue << dir_watcher
  end

  after do
    TestHelpers.dummy_temporary_source_dir_termination
  end

  it 'should upload files via all uploaders and delete source file' do
    expect(command_queue.queue).to eq([dir_watcher])
    expect_that_processing_dir_is_empty
    expect_that_local_dir_uploader_dir_is_empty

    command_queue.call_next

    expect(command_queue.queue).to match_array([
      be_kind_of(Bubbles::Uploaders::S3),
      be_kind_of(Bubbles::Uploaders::LocalDir),
      be_kind_of(Method), # this is instance of BubbliciousFile.public_method(:remove)
      dir_watcher,
    ])
    expect_that_file_exists_in_processing_dir
    expect_that_local_dir_uploader_dir_is_empty

    expect_upload_to_s3
    command_queue.call_next

    expect(command_queue.queue).to match_array([
      be_kind_of(Bubbles::Uploaders::LocalDir),
      be_kind_of(Method), # this is instance of BubbliciousFile.public_method(:remove)
      dir_watcher,
    ])
    expect_that_file_exists_in_processing_dir
    expect_that_local_dir_uploader_dir_is_empty

    command_queue.call_next

    expect(command_queue.queue).to match_array([
      be_kind_of(Method), # this is instance of BubbliciousFile.public_method(:remove)
      dir_watcher,
    ])
    expect_that_file_exists_in_processing_dir
    expect_that_file_exists_in_local_dir_uploader_dir

    command_queue.call_next
    expect(command_queue.queue).to match_array([
      dir_watcher,
    ])
    expect_that_processing_dir_is_empty
    expect_that_file_exists_in_local_dir_uploader_dir
  end

  def expect_upload_to_s3
    s3_double = instance_double(Aws::S3::Client)
    expect(Aws::S3::Client)
      .to receive(:new)
      .with({region: 'eu-west-1', credentials: config.s3_credentials })
      .and_return(s3_double)

    expect(s3_double)
      .to receive(:put_object)
      .with(bucket: 'mybckt', key: /\w*-\w*-\w*-\w*-\w*\.jpg/, body: be_kind_of(File), acl: 'private', metadata: {:original_name=>"test1.jpg"})
      .and_return(true)
  end

  def expect_that_file_exists_in_processing_dir
    expect(Dir.glob(TestHelpers.dummy_processing_dir + '/**/*').size).to be 1
  end

  def expect_that_processing_dir_is_empty
    expect(Dir.glob(TestHelpers.dummy_processing_dir + '/**/*')).to be_empty
  end

  def expect_that_local_dir_uploader_dir_is_empty
    expect(Dir.glob(TestHelpers.dummy_local_dir_uploader_dir + '/**/*')).to be_empty
  end

  def expect_that_file_exists_in_local_dir_uploader_dir
    expect(Dir.glob(TestHelpers.dummy_local_dir_uploader_dir + '/**/*').size).to be 1
  end
end
