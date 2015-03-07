module TradersHelper
  def pretty_last_update
    last_update.strftime("%b %e, %Y %H:%M %Z")
  end

  def last_update
    Cambio.order('updated_at DESC').first.updated_at
  end
end
