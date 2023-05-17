class Transaction < ApplicationRecord
  validates :credit_card_number, :credit_card_expiration_date, presence: true
  validates :result, presence: true, inclusion: { in: %w(failed success refunded) }
  belongs_to :invoice
end
