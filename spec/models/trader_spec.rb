require 'rails_helper'

RSpec.describe Trader, type: :model do
  it { is_expected.to have_many(:currencies) }
end
