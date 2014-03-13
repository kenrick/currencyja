require 'spec_helper'

describe TweetDecorator do
  let(:trader) { double(short_name: "NCB") }
  let(:previous) { double(trader: trader, note: "usd", buy_cash: BigDecimal.new("106.10")) }
  let(:current) { double(trader: trader, note: "usd", buy_cash: BigDecimal.new("106.40")) }
  let(:rate_type) { :buy_cash }
  subject(:decorator) { TweetDecorator.new(current, previous, rate_type) }

  describe "#build_tweet" do

    context "given the buy_cash rate increase for NCB" do
      it "should return a structured comparison string" do
        decorator.build_tweet.should eq("@ncbja has changed their cash buying #USD rate #up from $106.10 to $106.40. (+0.30)")
      end
    end

    context "given the sell_cash rate decreased for FXTRADERS" do

      let(:trader) { double(short_name: "FXTRADERS") }
      let(:previous) { double(trader: trader, note: "usd", sell_cash: BigDecimal.new("108.25")) }
      let(:current) { double(trader: trader, note: "usd", sell_cash: BigDecimal.new("107.00")) }
      let(:rate_type) { :sell_cash }

      it "should return a structured comparison string" do
        decorator.build_tweet.should eq("FXTRADERS has changed their cash selling #USD rate #down from $108.25 to $107.00. (-1.25)")
      end
    end

  end
end
