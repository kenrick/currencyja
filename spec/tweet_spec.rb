require 'spec_helper'

describe Tweet do

  let(:client) { double(update: true) }
  let(:tweet) { Tweet.new }

  describe "send" do

    before do
      Twitter::REST::Client.stub(:new).and_return(client)
    end

    it "should send a tweet" do
      client.should_receive(:update).with("a tweet")
      tweet.create "a tweet"
    end
  end
end
