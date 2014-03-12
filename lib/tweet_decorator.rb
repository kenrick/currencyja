class TweetDecorator < Struct.new(:current, :previous, :rate_type)

  HUMAN_RATE_TYPES = {
    buy_cash: "cash buying",
    buy_draft: "draft buying",
    sell_cash: "cash selling",
    sell_draft: "draft selling"
  }

  TRADER_TWITTER_HANDERS = {
    "NCB" => "@ncbja",
    "JMMB" => "@JMMBGROUP",
    "BNS" => "@ScotiabankJM",
    "JNBS" => "@JamaicaNational",
    "FGB" => "@First_Global",
    "Sagicore" => "@SagicorJa",
  }

  def build_tweet
    "#{trader_handle} has changed their #{human_rate_type} #{note_hash_tag} rate #{movement} from $#{previous_amount} to $#{current_amount}. (#{amount_difference})"
  end

  private

  def amount_difference
    amount = bg_to_money(difference)
    amount.insert(0, "+") if difference > 0
    amount
  end

  def trader_handle
    TRADER_TWITTER_HANDERS[trader_short_name] || trader_short_name
  end

  def trader_short_name
    current.trader.short_name
  end

  def human_rate_type
    HUMAN_RATE_TYPES[rate_type]
  end

  def note_hash_tag
    "##{current.note.upcase}"
  end

  def previous_amount
    bg_to_money(previous.send(rate_type))
  end

  def current_amount
    bg_to_money(current.send(rate_type))
  end

  def difference
    current.send(rate_type) - previous.send(rate_type)
  end

  def movement
    difference > 0 ? "#up" : "#down"
  end

  def bg_to_money(bg)
    "%.2f" % bg.to_s("F")
  end
end
