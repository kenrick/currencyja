require_relative "../lib/traders/scotiabank.rb"
require 'vcr'
require 'vcr_helper'

describe ScotiaBank do

  let(:scotiabank) do
    VCR.use_cassette('jamaica.scotiabank.com') do
      ScotiaBank.new
    end
  end

  it "fetches the foriegn exchange page source" do
    scotiabank.site.should include("Foreign Exchange")
  end

  it "returns the buying rate for a US dollar" do
    scotiabank.exchange_rate_for(:usd, :buying).should be_kind_of(Float)
  end

  it "should confirm the selling rate of a USD is higher than the buying rate" do
    scotiabank.exchange_rate_for(:usd, :selling).should be > scotiabank.exchange_rate_for(:usd, :buying)
  end

end
