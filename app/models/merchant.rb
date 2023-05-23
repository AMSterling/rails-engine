class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  scope :find_merchant, ->(name) { where('name ILIKE ?', "%#{name}%") }

  def self.items_sold(qty)
    joins(invoices: [:transactions, :invoice_items])
    .where(transactions: { result: 'success' })
    .select('merchants.*, SUM(invoice_items.quantity) AS count')
    .group('merchants.id')
    .order('count DESC')
    .take(qty)
  end

  def self.highest_revenue(qty)
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
    .where('transactions.result = ?', 'success')
    .group('merchants.id')
    .order('revenue desc')
    .take(qty)
  end

  def revenue
    invoices.joins(:invoice_items, :transactions)
    .where(transactions: {result: 'success'})
    .pluck('sum(invoice_items.quantity * invoice_items.unit_price)')
    .first
  end

  def as_json(options={})
    options[:methods] = [:revenue]
    super
  end
  #
  # def this_method
  #   (caller[0][/`([^’]*)’/, 1]).to_s
  # end
end
