require File.join(File.dirname(__FILE__), '..', 'currencyja')
require "shoulda"

describe Currency do
  it { should belong_to(:trader) }
end
