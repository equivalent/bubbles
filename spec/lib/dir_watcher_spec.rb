require 'spec_helper'

RSpec.describe Bubbles::DirWatcher do
  class DummyUploader1
    attr_reader :bfile

    def initialize(bfile:)
      @bfile = bfile
    end

    def ==(other)
      self.class == other.class && self.bfile == other.bfile
    end
  end

  class DummyUploader2 < DummyUploader1; end

  subject do
    described_class.new({
      source_dir: source_dir,
      processing_dir: processing_dir,
      command_queue: command_queue,
      uploader_classes: uploader_classes
    })
  end

  let(:source_dir)     { TestHelpers.dummy_source_dir }
  let(:processing_dir) { TestHelpers.dummy_processing_dir }
  let(:command_queue)  { [] }
  let(:uploader_classes) { [DummyUploader1, DummyUploader2] }
  let(:bfile_double)   { instance_double(Bubbles::BubbliciousFile) }

  describe '#call' do
    def trigger; subject.call end

    it do
      destroyer_object = double

      expect(Bubbles::BubbliciousFile)
        .to receive(:new)
        .with(file: TestHelpers.dummy_file_test2, processing_dir: Pathname.new(processing_dir))
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

      expect(command_queue.shift).to eq DummyUploader1.new(bfile: bfile_double)
      expect(command_queue.shift).to eq DummyUploader2.new(bfile: bfile_double)
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
