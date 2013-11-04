require 'active_support/core_ext/string'
require_relative 'trader.rb'

class Trader::TableBase < Trader::Base

  class << self

    def parsed_markup(doc)
      @doc = doc
      build_currencies(labelled_columns)
    end

    # build_currencies(currency: 0, buying: buying, selling: selling)
    def build_currencies(data_columns={})
      currency = data_columns.delete(:currency) || 0

      rates_table.css('tr').each_with_object({}) do |tr, currencies|
        cells = tr.css('td')

        currency_code = Currency.translate_code(cells[currency].content)
        next unless Currency.code_valid?(currency_code)

        currencies[currency_code] = column_labels.each_with_object({}) do |column_label, rates|
          rate_column = data_columns[column_label]
          rate_node = cells[rate_column]
          rates[column_label] = Currency.value(rate_node.content)
        end
      end
    end

    def column_labels
      [:buying, :selling]
    end

  end

  class Currency

    class << self

      # converts the currency to it's storage representation
      def value(string)
        string.strip.to_f
      end

      # TODO validate the currency codes via http://www.xe.com/iso4217.php
      def code_valid?(currency_code)
        !currency_code.blank? && currency_code.length == 3
      end

      def translate_code(string)
        string.strip.
          # Replace currency symbols with letter equivalent
          # TODO go crazy and add the rest http://www.xe.com/symbols.php
          gsub('$', 'D').

          # Remove all non word charactes ([^A-Za-z0-9_])
          gsub(/\W/,'').

          # TODO we should perhaps consider not downcasing and preserving uppercase codes
          downcase

      end
    end
  end

end
