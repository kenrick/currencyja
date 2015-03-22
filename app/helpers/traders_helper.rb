module TradersHelper
  def pretty_last_update
    last_update.strftime("%b %e, %Y %H:%M %Z")
  end

  def last_update
    Trader.last_updated.updated_at.to_time
  end
end
