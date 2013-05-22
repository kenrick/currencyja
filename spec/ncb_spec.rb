require_relative "../lib/traders/ncb.rb"
require 'vcr'
require 'vcr_helper'

describe NCB do

  before do
    VCR.use_cassette('jncb.com') do
      NCB.site
    end
  end

  it "fetches the foriegn exchange page source" do
    NCB.site.should include("Foreign Exchange")
  end

  it "returns the buying rate for a US dollar" do
    NCB.exchange_rate_for(:usd, :buying).should be_kind_of(Float)
  end

  it "should confirm the selling rate of a USD is higher than the buying rate" do
    NCB.exchange_rate_for(:usd, :selling).should be > NCB.exchange_rate_for(:usd, :buying)
  end

end
