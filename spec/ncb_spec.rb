require_relative "../lib/traders/ncb.rb"
require 'vcr'
require 'vcr_helper'

describe NCB do

  let(:ncb) do
    VCR.use_cassette('jncb.com') do
      NCB.new
    end
  end

  it "fetches the foriegn exchange page source" do
    ncb.site.should include("Foreign Exchange")
  end

  it "returns the buying rate for a US dollar" do
    ncb.exchange_rate_for(:usd, :buying).should be_kind_of(Float)
  end

  it "should confirm the selling rate of a USD is higher than the buying rate" do
    ncb.exchange_rate_for(:usd, :selling).should be > ncb.exchange_rate_for(:usd, :buying)
  end

end
