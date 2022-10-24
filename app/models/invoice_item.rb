class InvoiceItem < ApplicationRecord
  validates :quantity, :unit_price, presence: true

  belongs_to :item
  belongs_to :invoice
end
