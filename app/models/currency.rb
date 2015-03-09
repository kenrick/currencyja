class Currency < ActiveRecord::Base
  Notes = %w{ USD EUR CAD GBP }

  belongs_to :trader
end
