class Currency < ActiveRecord::Base
  NOTES = %w{ USD EUR CAD GBP }

  belongs_to :trader
end
