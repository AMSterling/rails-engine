class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  scope :find_merchant, ->(name) { where('name ILIKE ?', "%#{name}%") }
  # scope :find_most_sold, ->(quantity) { self.most_items_sold.take(quantity) }
  # scope :ordered, -> {
  #   joins(items: {invoice_items: {invoices: :transactions}})
  #   .where(transactions: {result: "success"})
  #   .select('merchants.id, sum(invoice_items.quantity) as items_sold')
  #   .group('merchants.id, items.id, invoice_items.id')
  #   .order('items_sold').first
  # }

  def self.most_items_sold(arg)
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.id, merchants.name, sum(invoice_items.quantity) as items_sold')
    .where(transactions: {result: "success"})
    .group('merchants.id')
    .order('items_sold desc')
    .take(arg)
    .pluck(:id, :name, 'items_sold')
  end

  def self.merch_items_sold(arg)
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.id, merchants.name, sum(invoice_items.quantity) as items_sold')
    .where(transactions: {result: "success"})
    .group('merchants.id')
    .order('items_sold desc')
    .find(arg).items_sold
  end

  def self.highest_revenue(arg)
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.id, merchants.name, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .where('transactions.result =?', 'success')
    .group('merchants.id')
    .order('total_revenue desc')
    .take(arg)
    .pluck(:id, :name, 'total_revenue')
  end

  def self.merchant_revenue(arg)
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.id, merchants.name, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .where('transactions.result = ?', 'success')
    .group('merchants.id')
    .order('total_revenue desc')
    .find(arg).total_revenue
  end
end
# Merchant.includes(items: {invoice_items: {invoice: :transactions}}).where(transactions: {result: "success"}).select('merchants.id, invoice_items.*, sum(invoice_items.quantity) as items_sold').group('merchants.id, items.id, invoice_items.id').order('items_sold').first
# Merchant.includes(items: {invoice_items: {invoice: :transactions}}).select('merchants.id, invoice_items.*, sum(invoice_items.quantity) as items_sold').group('merchants.id, items.id, invoice_items.id').order('items_sold').first
# Merchant.includes(items: {invoice_items: {invoice: :transactions}}).select('merchants.id, invoice_items.*, sum(invoice_items.quantity) as items_sold').group('merchants.id, items.id, invoice.id, invoice_items.id').order('items_sold').references(:items).references(:invoices)
# Merchant.joins(items: {invoice_items: {invoice: :transactions}}).select('merchants.id, sum(invoice_items.quantity) as items_sold').group('merchants.id, items.id, invoices.id').order('items_sold').references(:items).references(:invoices)
# joins(invoices: [:invoice_items, :transactions]).select('merchants.id, sum(invoice_items.quantity) as items_sold').where(transactions: {result: "success"}).group('merchants.id').order('items_sold')
