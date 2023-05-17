class Invoice < ApplicationRecord
  validates :status, presence: true, inclusion: { in: %w(packaged shipped returned) }

  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy#,  -> { order('sum("quantity")') },
  has_many :items, through: :invoice_items

  # scope :successful_by_quantity, -> { includes(:invoice_items, :transactions).where(transactions: {result: "success"}).select('invoice_items.*').order('invoice_items.quantity') }

  def self.delete_empty_invoice
    item_invoices = includes(:items)
    .group('invoices.id')
    .having('count(items) = 1')
    .pluck(:id)
    Invoice.destroy(item_invoices)
  end
end

# def self.delete_empty_invoice
  # item_invoices = joins(:items)
  # .select('invoices.*')
  # .group('invoices.id')
  # .having('count(items) = 1')
  # .pluck(:id)
  # Invoice.destroy(item_invoices)
# end
