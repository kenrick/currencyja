require "./currencyja"
require "sinatra/activerecord/rake"
task :update_traders  do |t|

  Forex::Trader.all.each do |trader, klass|
    begin
        trader = Trader.where(name: klass.name, short_name: trader).first_or_create
        fetch_currencies = klass.fetch
        unless fetch_currencies.empty?
            Cambio.where(name: klass.name).first_or_create.update_attributes(currencies: fetch_currencies)
            puts "Updated #{trader}"

            Currency::NOTES.each do |note|
                TraderUpdater.new(trader, note, fetch_currencies).update
            end
        end
    rescue Exception => e
        puts "Failed to Parse #{trader.short_name} because of #{e}"
    end
  end
end

task :console do
    binding.pry
end
