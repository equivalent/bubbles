require 'spec_helper'

RSpec.describe Bubbles::Config do
  subject { described_class.new }

  before do
    subject.use_default_config_locations = false
  end

  shared_context 'use dummy config1' do
    before { subject.config_path = TestHelpers.dummy_config1 }
  end

  shared_context 'use dummy config2' do
    before { subject.config_path = TestHelpers.dummy_config2 }
  end

  shared_examples 'method raising exception if config not provided' do
    context 'no config exist' do
      it do
        expect { result }.to raise_exception(/Please provide configuration file/)
      end
    end
  end

  describe '#config_path' do
    let(:result) { subject.config_path }

    context 'config was passed as config_path= argument' do
      before { subject.config_path = config_path_argument }

      context 'and file exist' do
        let(:config_path_argument) { TestHelpers.dummy_config1 }

        it 'should use that file' do
          expect(result).to eq(config_path_argument)
        end
      end

      context 'and file does not exist' do
        let(:config_path_argument) { 'tmp/foo baar caar' }

        it do
          expect { result }.to raise_exception(/foo baar caar does not exist/)
        end
      end
    end

    context 'config_path was not passed via attr_writer' do
      before(:each) do
        subject.use_default_config_locations = true
      end

      after(:each) do
        subject.use_default_config_locations = false
      end

      context 'var config exists' do
        before do
          expect(described_class).to receive(:var_config).twice.and_return TestHelpers.dummy_config1
        end

        it('should use that file'){ expect(result).to eq TestHelpers.dummy_config1 }
      end

      context 'home config exists' do
        before do
          expect(described_class).to receive(:home_config).twice.and_return TestHelpers.dummy_config1
        end

        it('should use that file'){ expect(result).to eq TestHelpers.dummy_config1 }
      end
    end
  end

  describe '#source_dir' do
    let(:result) { subject.source_dir }

    it_behaves_like 'method raising exception if config not provided'

    context 'config provided' do
      include_context 'use dummy config1'

      it 'expects to load pathname from config file'  do
        expect(subject.source_dir).to eq(Pathname.new('/tmp/source_dir_via_conig_file'))
      end
    end
  end

  describe '#processing_dir' do
    let(:result) { subject.processing_dir }

    it_behaves_like 'method raising exception if config not provided'

    context 'config provided' do
      include_context 'use dummy config1'

      it 'expects to load pathname from config file' do
        expect(result).to eq(Pathname.new('/tmp/processing_dir_via_conig_file'))
      end
    end
  end

  describe '#uploader_classes' do
    let(:result) { subject.uploader_classes }

    context 'by default' do
      include_context 'use dummy config1'

      it do
        expect(result).to eq([Bubbles::Uploaders::S3])
      end
    end

    context 'when config include uploaders' do
      include_context 'use dummy config2'

      it do
        expect(result).to eq([Bubbles::Uploaders::S3, Bubbles::Uploaders::LocalDir])
      end
    end
  end

  describe '#logger' do
    let(:result) { subject.logger }

    context 'by default' do
      include_context 'use dummy config1'

      it 'it is STDOUT logger with log level :debug' do
        expect(result).to be_kind_of(Logger)
        expect(result.level).to eq :debug # 0 represents debug
      end
    end

    context 'customized' do
      include_context 'use dummy config2'

      it 'it should accept config file' do
        expect(result).to be_kind_of(Logger)
        expect(result.level).to eq 1
      end
    end
  end
end
