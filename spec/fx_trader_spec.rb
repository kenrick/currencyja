require_relative "../lib/traders/fx_trader.rb"
require 'vcr'
require 'vcr_helper'

describe FXTrader do

  before do
    VCR.use_cassette('fxtrader.com') do
      FXTrader.site
    end
  end

  it "fetches the foriegn exchange page source" do
    FXTrader.site.should include("exchange rates")
  end

  it "returns the buying rate for a US dollar" do
    FXTrader.exchange_rate_for(:usd, :buying).should be_kind_of(Float)
  end

  it "should confirm the selling rate of a USD is higher than the buying rate" do
    FXTrader.exchange_rate_for(:usd, :selling).should be > FXTrader.exchange_rate_for(:usd, :buying)
  end

end
