class TradersController < ApplicationController
  def index
    @traders = Trader.includes(:currencies).all
    gon.rabl "app/views/api/traders/index.json.rabl", as: "traders"
  end
end
