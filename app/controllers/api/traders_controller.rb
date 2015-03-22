module Api
  class TradersController < ApplicationController
    respond_to :json

    def index
      @traders = Trader.includes(:currencies).all
    end
  end
end
