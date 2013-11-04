require_relative 'trader'
require_relative "table_base"

class JMMB < Trader::TableBase

  # Internal: Site URL with holds the foriegn exchange rates for JMMB
  ENDPOINT = "http://www.jmmb.com/full_rates.php"

  class << self

    def labelled_columns
      { currency: 0, buying: 1, selling: 4 }
    end

    def rates_table
      @doc.search("[text()*='FX Trading Rates']").first.  # Section with rates
        ancestors('table').first.                         # Root table for section
        css("table").first                                # Rates table
    end

  end

end
