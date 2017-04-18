require 'spec_helper'
RSpec.describe Bubbles::Uploaders::LocalDir do
  include_context 'common uploader initialization'
  include_context 'common uploader command_queue setup'


  let(:bfile)    { instance_double(Bubbles::BubbliciousFile, uid_file: uid_file) }
  let(:config) do
    Bubbles::Config.new.tap do |c|
      c.use_default_config_locations = false
      c.local_dir_uploader_path = TestHelpers.dummy_local_dir_uploader_dir
      c.log_level = TestHelpers.log_level
    end
  end

  describe '#call' do
    def trigger; subject.call end

    context 'successful file transfer' do
      include_context 'successful uploader file transfer preparation'

      def copied_file
        Pathname.new(TestHelpers.dummy_local_dir_uploader_dir).join('test1.jpg')
      end

      it_behaves_like 'uploader that keeps file in processing direcory'

      it 'adds the file to LocalDir Uploader destination' do
        expect(copied_file).not_to be_file
        trigger
        expect(copied_file).to be_file
      end

      it 'should not reschedule' do
        expect { trigger }.not_to change { command_queue.queue.size }
      end
    end

    context 'unseccessful file transfer' do
      let(:uid_file) do
        TestHelpers.dummy_file_test1_processing_dir
      end

      it 'should reschedule in front of command_queue' do
        expect { trigger }.to change { command_queue.queue.size }
        expect(command_queue.queue.first).to eq subject
      end
    end
  end
end
