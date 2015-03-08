class TradersController < ApplicationController
  def index
    @traders = Trader.includes(:currencies).all
    gon.rabl as: "traders"
  end
end
