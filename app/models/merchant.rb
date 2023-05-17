class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  scope :find_merchant, ->(name) { where('name ILIKE ?', "%#{name}%") }
  # scope :most_items_sold, ->(quantity) { items_sold.take(quantity) }

  def self.most_items_sold(arg)
    sold = joins(invoices: [:invoice_items, :transactions])
    .select('merchants.id, merchants.name, sum(invoice_items.quantity) as items_sold')
    .where(transactions: {result: "success"})
    .group('merchants.id')
    .order('items_sold desc')
    .take(arg)
    .pluck(:id, :name, 'items_sold')
    .map do |id, name, count|
      {
        id: id.to_s,
        type: 'items_sold',
        attributes: {
          name: name,
          count: count
        }
      }
    end
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
