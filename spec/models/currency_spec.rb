require 'rails_helper'

RSpec.describe Currency, type: :model do
  it { is_expected.to belong_to(:trader) }
end
