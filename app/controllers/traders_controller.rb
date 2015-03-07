class TradersController < ApplicationController
  def index
    gon.traders = Cambio.all
  end
end
