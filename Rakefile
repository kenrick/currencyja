require "./currencyja"
require "sinatra/activerecord/rake"

task :update_traders  do |t|

  Forex::Trader.all.each do |trader, klass|
    begin
        currencies = klass.fetch
        unless currencies.empty?
            Cambio.where(name: klass.name).first_or_create.update_attributes(currencies: currencies)
            puts "Updated #{trader}"
        end
    rescue Exception => e
        puts "Failed to Parse #{trader} because of #{e}"
    end
  end
end
