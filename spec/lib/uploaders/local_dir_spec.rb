require 'spec_helper'
RSpec.describe Bubbles::Uploaders::LocalDir do
  include_context 'common uploader initialization'
  let(:command_queue) { [] }
  let(:bfile)    { instance_double(Bubbles::BubbliciousFile, uid_file: uid_file) }
  let(:uid_file) do
    FileUtils.cp(TestHelpers.dummy_file_test1, TestHelpers.dummy_file_test1_processing_dir)
    TestHelpers.dummy_file_test1_processing_dir
  end
  let(:config) do
    Bubbles::Config.new.tap do |c|
      c.local_dir_uploader_path = TestHelpers.dummy_local_dir_uploader_dir
    end
  end

  describe '#call' do
    def trigger; subject.call end
    def copied_file
      Pathname.new(TestHelpers.dummy_local_dir_uploader_dir).join('test1.jpg')
    end

    it 'keeps the file in processing directory after operation' do
      expect(File.exist?(uid_file)).to be true
      trigger
      expect(File.exist?(uid_file)).to be true
    end

    it 'adds the file to LocalDir Uploader destination' do
      expect(copied_file).not_to be_file
      trigger
      expect(copied_file).to be_file
    end
  end
end
