task update_traders: [:environment]  do |t|
  ActiveRecord::Base.logger = nil # Mutes ActiveRecord verbose logger
  Forex::Trader.all.each do |trader, klass|
    begin
      trader = Trader.where(name: klass.name, short_name: trader).first_or_create
      fetch_currencies = klass.fetch
      unless fetch_currencies.empty?
        Cambio.where(name: klass.name).first_or_create.update_attributes(currencies: fetch_currencies)
        puts "Updated #{trader.short_name}"
      end
    rescue Exception => e
      puts "Failed to Parse #{trader.short_name} because of #{e}"
    end
  end
end
