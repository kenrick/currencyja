$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'forex'
require 'lib/tweet'
require 'lib/tweet_decorator'
require 'lib/trader_updater'

ActiveRecord::Base.include_root_in_json = false

# MODELS
class Cambio < ActiveRecord::Base
  serialize :currencies
end

class Trader < ActiveRecord::Base
  has_many :currencies
end

class Currency < ActiveRecord::Base
  NOTES = %w{ USD EUR CAD GBP }

  belongs_to :trader
end

set :database, ENV['DATABASE_URL'] || 'postgres://localhost/currencyja'

# HELPERS
helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def pretty_last_update
    last_update.strftime("%b %e, %Y %H:%M %Z")
  end

  def last_update
    Cambio.first(:order => 'updated_at DESC').updated_at
  end
end

# ROUTES
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

