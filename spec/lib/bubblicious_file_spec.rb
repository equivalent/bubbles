require 'spec_helper'

RSpec.describe Bubbles::BubbliciousFile do
  subject { described_class.new(file: file, config: config) }
  let(:file)           { TestHelpers.dummy_file_test1 }
  let(:source_dir)     { TestHelpers.dummy_source_dir }
  let(:processing_dir) { TestHelpers.dummy_processing_dir }
  let(:randomizer) { ->(){'abcdefgh'} }
  let(:expected_uid_file_path) { Pathname.new(processing_dir).join('abcdefgh.jpg') }

  let(:config) do
    Bubbles::Config.new.tap do |c|
      c.source_dir = source_dir
      c.processing_dir = processing_dir
      c.log_level      = TestHelpers.log_level
      c.uniq_filename_randomizer = randomizer
    end
  end

  describe '#move_to_processing_dir' do
    def trigger; subject.move_to_processing_dir end

    it 'moves file to processing dir with uuid name' do
      expect(FileUtils)
        .to receive(:mv)
        .once
        .with(Pathname.new(file), expected_uid_file_path)
      trigger
    end
  end

  describe '#metadata' do
    let(:result) { subject.metadata }

    it do
      expect(result).to match({
        original_name: 'test1.jpg'
      })
    end
  end

  describe '#remove_file' do
    def trigger; subject.remove_file end

    it 'remove uuid file from processing dir' do
      expect(FileUtils)
        .to receive(:rm)
        .once
        .with(expected_uid_file_path)
      trigger
    end
  end
end
