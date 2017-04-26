require 'spec_helper'

describe JRMonitor::Report::Process do
  subject(:process) { described_class.generate }

  describe "FD Stats" do
    it "should report open FDs" do
      expect(process["open_file_descriptors"]).to be > 0
    end

    it "should report max FDs possible" do
      expect(process["max_file_descriptors"]).to be > 0
    end
  end

  describe "mem stats" do
    subject(:mem) { process["mem"] }

    it "should report the virtual memory in bytes" do
      expect(mem["total_virtual_in_bytes"]).to be > 0
    end
  end

  describe "CPU stats" do
    subject(:cpu) { process["cpu"] }

    it "should report the CPU usage for the process" do
      expect(cpu["process_percent"]).to be >= 0
    end
    
    it "should report the CPU usage for the process" do
      expect(cpu["system_percent"]).to be >= 0
    end

    it "should report the total CPU time in millis" do
      expect(cpu["total_in_millis"]).to be > 0
    end
  end
  
end
