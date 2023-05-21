class Invoice < ApplicationRecord
  validates :status, presence: true, inclusion: { in: %w(packaged shipped returned) }

  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def self.delete_empty_invoice
    item_invoices = includes(:items)
    .group('invoices.id')
    .having('count(items) = 1')
    .pluck(:id)
    Invoice.destroy(item_invoices)
  end

  def self.revenue(start_date, end_date)
    joins(:invoice_items, :transactions)
    .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .where(
      status: 'shipped',
      created_at: (start_date..(Date.strptime(end_date, '%F') + 1).strftime('%F')),
      transactions: {result: 'success'}
    )
    .group('invoices.id')
    .pluck('sum(invoice_items.quantity * invoice_items.unit_price)')
    .sum
  end
end
