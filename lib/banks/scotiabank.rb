require 'nokogiri'
require 'net/http'

class ScotiaBank
  attr_accessor :site

  # Internal: Site URL with holds the foriegn exchange rates for scotiabank
  ENDPOINT = "http://www4.scotiabank.com/cgi-bin/ratesTool/depdisplay.cgi?pid=56"

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
  #   scotiabank.exchange_rate_for(:usd, :buying)
  #   # => 96.6
  #
  # Returns the exchange rate Float.
  def exchange_rate_for(currency_code, type)
    @currencies[currency_code.to_s][type]
  end

  private

    def parsed_markup(doc)
      currencies = Hash.new
      doc.css("table tr").each do |tr|
        table_cells = tr.css("td")
        currency_code = table_cells.first

        unless currency_code.nil? || currency_code.content == "Currency" || currency_code.content.empty?
          currencies[currency_code.content.downcase] = {
            buying: table_cells[1].content.to_f,
            selling: table_cells[3].content.to_r
          }
        end

      end
      currencies
    end
end