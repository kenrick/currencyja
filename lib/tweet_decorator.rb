class TweetDecorator < Struct.new(:current, :previous, :rate_type)

  HUMAN_RATE_TYPES = {
    buy_cash: "buying cash",
    buy_draft: "buying draft",
    sell_cash: "buying cash",
    sell_draft: "selling draft"
  }

  def build_tweet
    "#{trader_name} has changed their #{note} #{human_rate_type} rate from $#{previous_amount} to $#{current_amount}"
  end

  private

  def trader_name
    current.trader.name
  end

  def human_rate_type
    HUMAN_RATE_TYPES[rate_type]
  end

  def note
    current.note.upcase
  end

  def previous_amount
    bg_to_money(previous)
  end

  def current_amount
    bg_to_money(current)
  end

  def bg_to_money(currency)
    "%.2f" % currency.send(rate_type).to_s("F")
  end
end
