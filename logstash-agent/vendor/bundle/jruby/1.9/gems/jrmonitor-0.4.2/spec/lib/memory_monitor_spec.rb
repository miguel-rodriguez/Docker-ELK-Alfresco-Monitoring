require 'spec_helper'

describe JRMonitor::Report::Memory do

  let(:report) { subject.generate }

  it 'pulls usage for heap and non heap memory' do
    expect(report.keys).to include("heap")
    expect(report.keys).to include("non_heap")
  end

  context "#heap memory"do

    let(:report) { subject.generate_with_heap }

    it "pull usage for each space" do
      spaces = ["PS Survivor Space", "PS Old Gen", "PS Eden Space"]
      report.keys.each do |space|
        expect(spaces).to include(space);
      end
    end

    it "pull usage and peak info for each space" do
      report.each_pair do |_, values|
        expect(values).to include("usage.used" => kind_of(Fixnum))
        expect(values).to include("usage.max" => kind_of(Fixnum))
        expect(values).to include("usage.committed" => kind_of(Fixnum))
        expect(values).to include("usage.init" => kind_of(Fixnum))
        expect(values).to include("peak.used" => kind_of(Fixnum))
        expect(values).to include("peak.max" => kind_of(Fixnum))
        expect(values).to include("peak.committed" => kind_of(Fixnum))
        expect(values).to include("peak.init" => kind_of(Fixnum))
      end
    end
  end

end