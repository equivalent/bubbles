require 'spec_helper'
RSpec.describe Bubbles::Uploaders::S3 do
  include_context 'common uploader initialization'
  include_context 'common uploader command_queue setup'

  let(:bfile)    { instance_double(Bubbles::BubbliciousFile, uid_file: uid_file) }
  let(:config) do
    Bubbles::Config.new.tap do |c|
      c.local_dir_uploader_path = TestHelpers.dummy_local_dir_uploader_dir
    end
  end

  describe '#call' do
    def trigger; subject.call end

    context 'successful file transfer' do
      include_context 'successful uploader file transfer preparation'

      it_behaves_like 'uploader that keeps file in processing direcory'

      it do

      end

      it 'should not reschedule' do
        expect { trigger }.not_to change { command_queue.queue.size }
      end
    end
  end
end
