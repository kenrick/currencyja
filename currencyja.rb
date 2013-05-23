require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'activerecord-postgres-hstore'
require 'json'
require_relative 'lib/traders'

ActiveRecord::Base.include_root_in_json = false

class Cambio < ActiveRecord::Base
  serialize :currencies
end

set :database, ENV['DATABASE_URL'] || 'postgres://localhost/currencyja'


get '/' do
end

get '/api/traders.json' do
  content_type :json
  Cambio.all.to_json
end

get '/api/traders/:currency.json' do
  content_type :json
  Cambio.all.map { |cambio| { name: cambio.name, currency: cambio.currencies[params[:currency]]} }.to_json
end

