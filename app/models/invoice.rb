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

  def self.total_revenue(start_date, end_date)
    joins(:invoice_items, :transactions)
    .where(
      status: 'shipped',
      created_at: (start_date..(Date.strptime(end_date, '%F') + 1).strftime('%F')),
      transactions: { result: 'success' }
    )
    .group('invoices.id')
    .pluck('sum(invoice_items.quantity * invoice_items.unit_price)')
    .sum
  end

  def self.unshipped_order(qty)
    potential = joins(:transactions, :invoice_items)
    .where(transactions: { result: 'success' }, status: 'packaged')
    .select('invoices.id, SUM(invoice_items.quantity * invoice_items.unit_price) AS potential_revenue')
    .group('invoices.id')
    .order('potential_revenue desc')
    .take(qty)
  end

  def self.weekly_revenue
    weekly = joins(:transactions, :invoice_items)
    .where(transactions: { result: 'success' }, status: 'shipped')
    .group("date_trunc('week', invoices.created_at)")
    .order("date_trunc('week', invoices.created_at)")
    .select("date_trunc('week', invoices.created_at) AS week, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
  end
end
