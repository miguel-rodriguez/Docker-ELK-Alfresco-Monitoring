require 'spec_helper'

describe JRMonitor::Report::Threads do

  let(:threads) { subject.generate }

  it 'pull running threads' do
    expect(threads.keys.count).to be > 0
  end

  it 'fetch foreach threads information about cpu time' do
    threads.each_pair do |_, values|
      expect(values).to include('cpu.time')
    end
  end

  it 'fetch foreach threads information about thread state' do
    threads.each_pair do |_, values|
      expect(values).to include('thread.state')
    end
  end

  it 'fetch foreach threads information about blocked information' do
    threads.each_pair do |_, values|
      expect(values).to include('blocked.count')
      expect(values).to include('blocked.time')
    end
  end

  it 'fetch foreach threads information about waited information' do
    threads.each_pair do |_, values|
      expect(values).to include('waited.count')
      expect(values).to include('waited.time')
    end
  end

  it "fetched the stack traces" do
    threads.each_pair do |key, values|
      next if 'Signal Dispatcher' == key
      expect(values["thread.stacktrace"].count).to be > 0
    end
  end

  context "with options filtering" do

    let(:stacktrace_size) { 4 }
    let(:threads) do
      subject.generate(:stacktrace_size => stacktrace_size )
    end

    it "fetches N stack straces for each thread" do
      threads.each_pair do |key, values|
        next if ['Signal Dispatcher', 'Reference Handler'].include?(key)
        expect(values["thread.stacktrace"].count).to eq(stacktrace_size)
      end
    end
  end

  describe "#ordering" do

    let(:ordered_by) { "cpu" }

    let(:threads) do
      subject.generate(:ordered_by => ordered_by)
    end

    it 'fetch values ordered by cpu.time' do
      last_cpu_time = 0
      threads.each_pair do |_, values|
        current_cpu_time = values["cpu.time"]
        expect(last_cpu_time).to be >= current_cpu_time if last_cpu_time != 0
        last_cpu_time = current_cpu_time
      end
    end

    context "with block" do

      let(:type) { "block" }

      it 'fetch values ordered by blocked.time' do
        last_time = 0
        threads.each_pair do |_, values|
          current_time = values["blocked.time"]
          expect(last_time).to be >= current_time if last_time != 0
          last_time = current_time
        end
      end
    end

    context "with wait" do

      let(:type) { "wait" }

      it 'fetch values ordered by waited.time' do
        last_time = 0
        threads.each_pair do |_, values|
          current_time = values["waited.time"]
          expect(last_time).to be >= current_time if last_time != 0
          last_time = current_time
        end
      end
    end

  end
end