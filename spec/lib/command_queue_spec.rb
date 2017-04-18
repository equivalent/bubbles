require 'spec_helper'

RSpec.describe Bubbles::CommandQueue do
  subject { described_class.new(config: config) }
  let(:command_object) { double 'command_object1' }
  let(:config) do
    Bubbles::Config.new.tap do |c|
      c.use_default_config_locations = false
      c.log_level = TestHelpers.log_level
    end
  end

  describe '#queue' do
    it do
      expect(subject.queue).to be_kind_of(Array)
    end
  end

  describe '#<<' do
    def trigger; subject << command_object end

    it 'shauld add object to queue' do
      trigger
      expect(subject.queue).to eq([command_object])
    end

    context 'already existing command in the queue' do
      let(:existing_command) { double(:existing_command) }

      before do
        subject << existing_command
      end

      it 'should add to the end of queue' do
        trigger
        expect(subject.queue).to eq([existing_command, command_object])
      end
    end
  end

  describe '#call_next' do
    def trigger; subject.call_next end
    let(:command_object2) { double  'command_object2' }

    context 'nothing in the queue' do
      it do
        expect { trigger }.not_to raise_exception
      end
    end

    context 'something in the queue' do
      before do
        subject << command_object
        subject << command_object2
      end

      it do
        expect(command_object).to receive(:call).with(no_args).once
        expect(command_object2).not_to receive(:call)
        trigger
      end

      context 'run twice' do
        it do
          expect(command_object).to receive(:call).with(no_args).once
          expect(command_object2).to receive(:call).with(no_args).once
          2.times { trigger }
        end
      end
    end
  end

  describe '#reschedule' do
    def trigger; subject.reschedule command_object end
    let(:existing_command) { double(:existing_command) }

    before do
      subject << existing_command
    end

    it 'should add object to the front of the queue' do
      expect(subject.queue).to eq([existing_command])
      trigger
      expect(subject.queue).to eq([command_object, existing_command])
    end
  end
end
