require_relative 'trader.rb'

class FXTrader < Trader

  # Internal: Site URL with holds the foriegn exchange rates for fxtrader
  ENDPOINT = "http://www.fxtrader.gkmsonline.com/rates"

  def self.parsed_markup(doc)
    currencies = Hash.new

    (1..5).each do |number|
      country_code = doc.css(".views-field-field-fx-trader-currency-#{number}-value span").first.content.downcase
      buying_price = doc.css(".views-field-field-fx-trader-buying-#{number}-value span").first.content.to_f
      selling_price = doc.css(".views-field-field-fx-trader-selling-#{number}-value span").first.content.to_f

      currencies[country_code] = { buying: buying_price, selling: selling_price }
    end
    currencies
  end
end
