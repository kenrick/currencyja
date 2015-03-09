task update_traders: [:environment]  do |t|
  FetchError = StandardError

  ActiveRecord::Base.logger = nil # Mutes ActiveRecord verbose logger
  Forex::Trader.all.each do |trader_name, klass|
    begin
      fetched_currencies = klass.fetch
      raise FetchError if fetched_currencies.empty?

      trader = Trader.where(name: klass.name, short_name: trader_name).first_or_create

      Currency::Notes.each do |note|
        currency = trader.currencies.where(note: note).first_or_create!
        currency.update_attributes(fetched_currencies[note])
      end

      trader.touch
      puts "Updated #{trader_name}"
    rescue Exception => e
      puts "Failed to Parse #{trader_name} because of #{e}"
    end
  end
end
