require 'spec_helper'

describe TraderUpdater do
  let(:trader) { double }
  let(:previous) { double }
  let(:current) { double( buy_cash: BigDecimal.new("109.2"), sell_cash: BigDecimal.new("110.2"), attributes: currency_hash[note], save!: true ) }
  let(:last_attributes) { { buy_cash: BigDecimal.new("101.10"), sell_cash: BigDecimal.new("110.2") } }
  let(:last) { double( buy_cash: BigDecimal.new("101.10"), sell_cash: BigDecimal.new("110.2"), attributes: last_attributes ) }
  let(:any_exists?) { true }
  let(:note) { "USD" }
  let(:currency_hash) { { "USD" => { buy_cash: BigDecimal.new("109.28"), sell_cash: BigDecimal.new("110.2") } } }
  let(:decorator) { double(build_tweet: true)}
  let(:tweet) { double(create: true)}
  subject {TraderUpdater.new(trader, note, currency_hash)}

  before(:each) do
    trader.stub(:currencies) do
      double("currencies").tap do |proxy|

        proxy.stub(:where) do |where|
          double.tap do |p|
            p.stub(:last) do
              if where == {note: :usd}
                last
              else
                previous
              end
            end

            p.stub(:any?) do
              any_exists?
            end
          end
        end

        proxy.stub(:build) do
          current
        end
      end
    end

    TweetDecorator.stub(:new).and_return(decorator)
    Tweet.stub(:new).and_return(tweet)

  end

  describe "#previous_currency" do

    it "should return the previous currency record" do
      subject.previous_currency.should eq(previous)
    end

  end

  describe "#last_currency" do

    it "should return the last currency record" do
      subject.last_currency.should eq(last)
    end

  end

  describe "#currency_attributes" do

    it "should return the previous currency record" do
      subject.currency_attributes.should eq({ buy_cash: "109.28", sell_cash: "110.2", note: :usd })
    end

  end

  describe "#note_rates" do

    it "should return the rates for USD" do
      subject.note_rates.should eq(currency_hash["USD"])
    end

    context "trader is FXTrader" do
      let(:note) { "EUR"}
      let(:trader) { double(short_name: "FXTRADERS") }
      let(:currency_hash) { { "EURO" => { buy_cash: BigDecimal.new("109.2"), sell_cash: BigDecimal.new("110.2") } } }

      it "should return rates for EURO" do
        subject.note_rates.should eq(currency_hash["EURO"])
      end

    end
  end

  describe "#tweet_changes" do

    it "should send a tweet" do
      decorator.should_receive :build_tweet
      tweet.should_receive :create
      subject.tweet_changes(:any)
    end

  end

  describe "#compare_currency_rates" do
    context "when buy_cash is different" do

      it "should yield with buy_cash being changed" do

        yielded = []
        subject.compare_currency_rates do |changed|
          yielded << changed
        end

        yielded.should eq([:buy_cash])
      end
    end

    context "when buy_cash and sell_cash are different" do
      let(:last_attributes) { { buy_cash: BigDecimal.new("101.10"), sell_cash: BigDecimal.new("110.4") } }
      let(:last) { double( buy_cash: BigDecimal.new("101.10"), sell_cash: BigDecimal.new("110.4"), attributes: last_attributes ) }

      it "should yield with buy_cash being changed" do

        yielded = []
        subject.compare_currency_rates do |changed|
          yielded << changed
        end

        yielded.should eq([:buy_cash, :sell_cash])
      end
    end

  end

  describe "#update" do

    context "when a simular currency already exist" do

      it "should not create a currency" do
        current.should_not_receive(:save!)
        subject.update
      end

    end

    context "when the previous and current currencies don't match" do
      let(:previous) { nil }
      let(:any_exists?) { true }

      it "should compare the current and last currencies" do
        subject.should_receive(:compare_currency_rates)
        subject.update
      end

      it "should send a tweet with the changes in rates" do
        subject.should_receive(:tweet_changes).with(any_args())
        subject.update
      end

      it "should create the new currency" do
        current.should_receive(:save!)
        subject.update
      end

    end

    context "when no currencies exist" do
      let(:previous) { nil }
      let(:any_exists?) { false }

      it "should create the first currency" do
        subject.should_not_receive(:compare_currency_rates)
        current.should_receive(:save!)
        subject.update
      end
    end
  end
end
