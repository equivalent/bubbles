require 'spec_helper'
RSpec.describe Bubbles::Uploaders::S3 do
  include_context 'common uploader initialization'
  include_context 'common uploader command_queue setup'

  let(:uid_file_name) { 'test.jpg' }
  let(:bfile)  do
    instance_double Bubbles::BubbliciousFile,
      uid_file: uid_file,
      uid_file_name: uid_file_name
  end

  let(:config) do
    Bubbles::Config.new.tap do |c|
      c.local_dir_uploader_path = TestHelpers.dummy_local_dir_uploader_dir
      c.s3_region = 'eu-west-1'
      c.s3_bucket = 'mybckt'
      c.s3_access_key_id     = 'xxxxxxxxxxx'
      c.s3_secret_access_key = 'yyyyyyyyyyy'
    end
  end

  describe '#call' do
    def trigger; subject.call end

    context 'successful file transfer' do
      include_context 'successful uploader file transfer preparation'

      before do
        s3_double = instance_double(Aws::S3::Client)
        expect(Aws::S3::Client)
          .to receive(:new)
          .with({region: 'eu-west-1', credentials: config.s3_credentials })
          .and_return(s3_double)

        expect(s3_double)
          .to receive(:put_object)
          .with(bucket: 'mybckt', key: '/test.jpg', body: be_kind_of(File))
          .and_return(true)
      end

      it_behaves_like 'uploader that keeps file in processing direcory'

      it 'should not reschedule' do
        expect { trigger }.not_to change { command_queue.queue.size }
      end
    end
  end
end
