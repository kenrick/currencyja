require 'spec_helper'

describe TweetDecorator do
  let(:trader) { double(name: "National Bank") }
  let(:previous) { double(trader: trader, note: "usd", buy_cash: BigDecimal.new("106.10")) }
  let(:current) { double(trader: trader, note: "usd", buy_cash: BigDecimal.new("106.40")) }
  let(:rate_type) { :buy_cash }
  let(:decorator) { TweetDecorator.new(current, previous, rate_type) }

  describe "#build_tweet" do

    it "should return a structured comparison string" do
      decorator.build_tweet.should eq("National Bank has changed their USD buying cash rate from $106.10 to $106.40")
    end

  end
end
