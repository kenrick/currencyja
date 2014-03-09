require 'spec_helper'

describe Trader do
  it { should have_many(:currencies) }
end
