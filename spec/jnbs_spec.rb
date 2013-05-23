require_relative "../lib/traders/jnbs.rb"
require 'vcr'
require 'vcr_helper'

describe JNBS do

  before do
    VCR.use_cassette('jnbs.com') do
      JNBS.site
    end
  end

  it "fetches the foriegn exchange page source" do
    JNBS.site.should include("FX Rates")
  end

  it "returns the buying rate for a US dollar" do
    JNBS.exchange_rate_for(:usd, :buying).should be_kind_of(Float)
  end

  it "should confirm the selling rate of a USD is higher than the buying rate" do
    JNBS.exchange_rate_for(:usd, :selling).should be > JNBS.exchange_rate_for(:usd, :buying)
  end

end
