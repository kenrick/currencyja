require 'nokogiri'
require 'net/http'

class NCB
  attr_accessor :site

  # Internal: Site URL with holds the foriegn exchange rates for ncb
  ENDPOINT = "http://www.jncb.com/rates/foreignexchangerates"

  def initialize
    @site =  Net::HTTP.get(URI(ENDPOINT))
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
  #   ncb.exchange_rate_for(:usd, :buying)
  #   # => 96.6
  #
  # Returns the exchange rate Float.
  def exchange_rate_for(currency_code, type)
    @currencies[currency_code.to_s][type]
  end

  private

    def parsed_markup(doc)
      currencies = Hash.new
      doc.css(".rates table tr").each do |tr|
        table_cells = tr.css("td")
        currency_code = table_cells[1]

        currencies[currency_code.content.downcase] = {
          buying: table_cells[4].content.to_f,
          selling: table_cells[2].content.to_f
        }
      end
      currencies
    end
end