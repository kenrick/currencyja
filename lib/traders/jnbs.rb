require_relative 'trader.rb'

class JNBS < Trader::Base

  # Internal: Site URL with holds the foriegn exchange rates for ncb
  ENDPOINT = "http://www.jnbs.com/fx-rates-2"

  def self.parsed_markup(doc)
    currencies = Hash.new
    repeated = ""
    doc.css("table tr.row-4").each_with_index do |tr, index|
      cells = tr.css("td")
      country_code = cells.first.content.downcase
      break if repeated == country_code

      currencies[country_code] = {
        buying: cells[2].content.to_f,
        selling: cells[4].content.to_f
      }

      repeated = country_code if index == 0
    end
    currencies
  end

end