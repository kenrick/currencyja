require 'nokogiri'
require 'net/http'


class Trader

  class << self
    # Public: Finds the exchange rate for JMD to a given currency.
    #
    # currency_code - The 3 character Symbol that repsents the countries currency.
    # type - The Symbol indicating if its the buying or selling rate.
    #
    # Examples
    #
    #   Trader.exchange_rate_for(:usd, :buying)
    #   # => 96.6
    #
    # Returns the exchange rate Float.
    def exchange_rate_for(currency_code, type)
      currencies[currency_code.to_s][type]
    end

    def site
      @site ||= Net::HTTP.get(URI(self::ENDPOINT))
    end

    def currencies
      doc = Nokogiri::HTML(site)
      @currencies ||= parsed_markup(doc)
    end

  end
end
