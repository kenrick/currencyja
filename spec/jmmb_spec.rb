require_relative "../lib/traders/jmmb.rb"
require 'vcr'
require 'vcr_helper'

describe JMMB do

  before do
    VCR.use_cassette('jmmb.com') do
      JMMB.site
    end
  end

  it "fetches the foriegn exchange page source" do
    JMMB.site.should include("FX Trading Rates")
  end

  it "returns the buying rate for a US dollar" do
    JMMB.exchange_rate_for(:usd, :buying).should be_kind_of(Float)
  end

  it "should confirm the selling rate of a USD is higher than the buying rate" do
    JMMB.exchange_rate_for(:usd, :selling).should be > JMMB.exchange_rate_for(:usd, :buying)
  end

end
