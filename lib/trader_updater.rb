class TraderUpdater < Struct.new(:trader, :note, :currency_hash)

  def update

    unless previous_currency

      if any_currencies_exists?
        compare_currency_rates do |changed_rate|
          tweet_changes(changed_rate)
        end
      end

      current_currency.save!
    end
  end

  def previous_currency
    @previous_currency ||= trader.currencies.where(currency_attributes).last
  end

  def current_currency
    @current_currency ||= trader.currencies.build(currency_attributes)
  end

  def last_currency
    @last_currency ||= trader.currencies.where(note: note_symbol).last
  end

  def currency_attributes
    rates_hash.merge(note: note_symbol)
  end

  def note_symbol
    note.downcase.to_sym
  end

  def note_rates
    unless note == "EUR" && trader.short_name == "FXTRADERS"
      currency_hash[note]
    else
      currency_hash["EURO"]
    end
  end

  def any_currencies_exists?
    trader.currencies.where(note: note_symbol).any? || false
  end

  def tweet_changes(changed_rate)
    decorator = TweetDecorator.new(current_currency, last_currency, changed_rate)
    Tweet.new.create decorator.build_tweet
  end

  def compare_currency_rates
    changed = []
    rate_names = [:buy_cash, :buy_draft, :sell_cash, :sell_draft]
    last_currency.attributes.each do |attribute , _|
        attribute = attribute.to_sym
        if rate_names.include?(attribute)
            a, b = last_currency.send(attribute), current_currency.send(attribute)
            changed << attribute if a != b
        end
    end

    changed.each { |c| yield c }
  end

  private

  def rates_hash
    hash = Hash.new
    note_rates.each{ |key,val| hash[key] = val ? val.to_s : nil }
    hash
  end
end
