class Invoice < ApplicationRecord
  validates_presence_of :status

  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def self.delete_empty_invoice
    single_item_invoices = joins(:items)
    .select('invoices.*')
    .group('invoices.id')
    .having('count(items) = 1')
    .pluck(:id)
    Invoice.destroy(single_item_invoices)
  end
end
