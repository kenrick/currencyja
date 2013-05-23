require_relative 'trader.rb'

class ScotiaBank < Trader::Base

  # Internal: Site URL with holds the foriegn exchange rates for scotiabank
  ENDPOINT = "http://www4.scotiabank.com/cgi-bin/ratesTool/depdisplay.cgi?pid=56"

  def self.parsed_markup(doc)
    currencies = Hash.new
    doc.css("table tr").each do |tr|
      table_cells = tr.css("td")
      country_code = table_cells.first

      unless country_code.nil? || country_code.content == "Currency" || country_code.content.empty?
        currencies[country_code.content.downcase] = {
          buying: table_cells[1].content.to_f,
          selling: table_cells[3].content.to_f
        }
      end

    end
    currencies
  end
end
