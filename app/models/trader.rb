class Trader < ActiveRecord::Base
  scope :last_updated, -> { order('updated_at DESC').first }

  has_many :currencies

  def currencies_hash
    currencies.reduce({}) {
      |h, currency| h.merge(Hash[currency.note, currency])
    }
  end

  def status
    if updated_at > 1.hour.ago
      :green
    else
      :red
    end
  end
end
