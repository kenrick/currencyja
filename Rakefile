require "./currencyja"
require "sinatra/activerecord/rake"

task :update_traders  do |t|
  traders = {
    "scotiabank" => ScotiaBank,
    "ncb" => NCB,
    "fxtrader" => FXTrader,
    "jnbs" => JNBS,
    "jmmb" => JMMB
  }

  traders.each_pair do |trader, klass|
    begin
        currencies = klass.currencies
        unless currencies.empty?
            Cambio.where(name: trader).first_or_create.update_attributes(currencies: currencies)
        end
    rescue Exception => e
        puts "Failed to Parse #{trader} because of #{e}"
    end
  end
end
