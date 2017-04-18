require 'spec_helper'

RSpec.describe Bubbles::DirWatcher do
  class DummyUploader1
    include Bubbles::CommonUploaderInterface

    def ==(other)
      self.class == other.class && self.bfile == other.bfile
    end
  end

  class DummyUploader2 < DummyUploader1; end

  subject{ described_class.new(config: config, command_queue: command_queue) }
  let(:source_dir)     { TestHelpers.dummy_source_dir }
  let(:processing_dir) { TestHelpers.dummy_processing_dir }
  let(:command_queue)  { [] }
  let(:uploader_classes) { [DummyUploader1, DummyUploader2] }
  let(:bfile_double)   { instance_double(Bubbles::BubbliciousFile) }
  let(:config) do
    Bubbles::Config.new.tap do |c|
      c.use_default_config_locations = false
      c.source_dir = source_dir
      c.processing_dir = processing_dir
      c.uploader_classes = uploader_classes
    end
  end

  describe '#source_dir_files' do
    let(:result) { subject.source_dir_files }
    it 'expect to enlist folders only' do
      expect(result.size).to be 2
      expect(result).to match_array([/test1\.jpg/, /test2\.png/])
    end
  end

  describe '#call' do
    def trigger; subject.call end

    it do
      destroyer_object = double

      expect(Bubbles::BubbliciousFile)
        .to receive(:new)
        .with(file: TestHelpers.dummy_file_test2, config: config)
        .and_return(bfile_double)
      expect(bfile_double)
        .to receive(:move_to_processing_dir)
        .with(no_args)

      expect(bfile_double)
        .to receive(:public_method)
        .with(:remove_file)
        .and_return(destroyer_object)

      trigger
      expect(command_queue.size).to eq 4

      dummy_uploader1 = DummyUploader1.new(bfile: bfile_double, config: config, command_queue: command_queue)
      expect(command_queue.shift).to eq dummy_uploader1

      dummy_uploader2 = DummyUploader2.new(bfile: bfile_double, config: config, command_queue: command_queue)
      expect(command_queue.shift).to eq dummy_uploader2
      expect(command_queue.shift).to eq destroyer_object
      expect(command_queue.shift).to eq subject
    end

    context 'source directory does not exist' do
      let(:source_dir) { '/foo bar car' }

      it do
        expect { trigger }.to raise_exception(Bubbles::DirWatcher::DestinationIsNotDirectory)
      end
    end

    context 'source directory location is a file' do
      let(:source_dir) { TestHelpers.dummy_file_test1 }

      it do
        expect { trigger }.to raise_exception(Bubbles::DirWatcher::DestinationIsNotDirectory)
      end
    end

    context 'processing_dir does not exist' do
      let(:processing_dir) { '/foo bar car' }

      it do
        expect { trigger }.to raise_exception(Bubbles::DirWatcher::DestinationIsNotDirectory)
      end
    end

    context 'processing_dir location is a file' do
      let(:processing_dir) { TestHelpers.dummy_file_test1 }

      it do
        expect { trigger }.to raise_exception(Bubbles::DirWatcher::DestinationIsNotDirectory)
      end
    end
  end

  describe '#inspect' do
    it { expect(subject.inspect).to eq "#<Bubbles::DirWatcher source_dir: #{TestHelpers.dummy_source_dir}, processing_dir: #{TestHelpers.dummy_processing_dir}>" }
  end
end
