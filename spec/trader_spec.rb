require File.join(File.dirname(__FILE__), '..', 'currencyja')
require "shoulda"

describe Trader do 
  it { should have_many(:currencies) }
end
