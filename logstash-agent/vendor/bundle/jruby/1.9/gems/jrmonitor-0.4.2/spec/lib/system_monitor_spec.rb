require 'spec_helper'

describe JRMonitor::Report::System do

  let(:report) { subject.generate }

  it 'pulls system load information' do
    expect(report).to include( "system.load_average" => a_kind_of(Float) )
  end

  it 'pulls system available processors information' do
    expect(report).to include( "system.available_processors" => a_kind_of(Fixnum) )
  end

  it 'pulls os version information' do
    expect(report).to include( "os.version" => a_kind_of(String) )
  end

  it 'pulls os arch information' do
    expect(report).to include( "os.arch" => a_kind_of(String) )
  end

  it 'pulls os name information' do
    expect(report).to include( "os.name" => a_kind_of(String) )
  end

end