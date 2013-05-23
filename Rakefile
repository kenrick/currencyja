require "./currencyja"
require "sinatra/activerecord/rake"

task :update_traders  do |t|
  Cambio.where(name: "scotiabank").first_or_create.update_attributes(currencies: ScotiaBank.currencies)
  Cambio.where(name: "ncb").first_or_create.update_attributes(currencies: NCB.currencies)
  Cambio.where(name: "fxtrader").first_or_create.update_attributes(currencies: FXTrader.currencies)
  Cambio.where(name: "jnbs").first_or_create.update_attributes(currencies: JNBS.currencies)
end