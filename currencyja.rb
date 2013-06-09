require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require_relative 'lib/traders'

ActiveRecord::Base.include_root_in_json = false

class Cambio < ActiveRecord::Base
  serialize :currencies
end

set :database, ENV['DATABASE_URL'] || 'postgres://localhost/currencyja'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def pretty_last_update
    Cambio.first.updated_at.strftime("%b %e, %Y %H:%M %Z")
  end

  def last_update
    Cambio.first.updated_at
  end
end


get '/' do
  @cambios = Cambio.all.to_json
  erb :index
end

get '/api/traders.json' do
  content_type :json
  Cambio.all.to_json
end

get '/api/traders/:currency.json' do
  content_type :json
  Cambio.all.map do |cambio|
    { name: cambio.name, currency: cambio.currencies[params[:currency]], updated_at: cambio.updated_at}
  end.to_json
end

