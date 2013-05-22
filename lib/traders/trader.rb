require 'nokogiri'
require 'net/http'


class Trader
  attr_accessor :site

  def initialize
    @site =  Net::HTTP.get(URI(self.class::ENDPOINT))
    doc  =  Nokogiri::HTML(@site)
    @currencies = parsed_markup(doc)
  end

  # Public: Finds the exchange rate for JMD to a given currency.
  #
  # currency_code - The 3 character Symbol that repsents the countries currency.
  # type - The Symbol indicating if its the buying or selling rate.
  #
  # Examples
  #
  #   trader.exchange_rate_for(:usd, :buying)
  #   # => 96.6
  #
  # Returns the exchange rate Float.
  def exchange_rate_for(currency_code, type)
    @currencies[currency_code.to_s][type]
  end

end
