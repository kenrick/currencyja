require_relative 'trader.rb'

class NCB < Trader

  # Internal: Site URL with holds the foriegn exchange rates for ncb
  ENDPOINT = "http://www.jncb.com/rates/foreignexchangerates"

  def self.parsed_markup(doc)
    currencies = Hash.new
    doc.css(".rates table tr").each do |tr|
      table_cells = tr.css("td")
      country_code = table_cells[1]

      currencies[country_code.content.downcase] = {
        buying: table_cells[4].content.to_f,
        selling: table_cells[2].content.to_f
      }
    end
    currencies
  end
end
