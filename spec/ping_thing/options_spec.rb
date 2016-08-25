require 'spec_helper'

describe PingThing::Options do
  it 'parses -url option' do
    expect(described_class.parse(%w(-u https://hashrocket.com))).to include(url: "https://hashrocket.com")
  end

  it 'default -limit option' do
    expect(described_class.parse([])).to include(limit: 1000)
  end

  it 'parses -limit option' do
    expect(described_class.parse(%w(-l 50))).to include(limit: 50)
  end
end
