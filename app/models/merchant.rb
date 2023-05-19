class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  scope :find_merchant, ->(name) { where('name ILIKE ?', "%#{name}%") }
  scope :items_sold, ->(quantity) { ordered_by_most_sold.take(quantity.to_i) }
  scope :top_revenue, ->(quantity) { highest_revenue.take(quantity.to_i) }

  def self.ordered_by_most_sold
    result = joins(invoices: [:transactions, :invoice_items])
    .where(transactions: { result: 'success' })
    .group('merchants.id')
    .select('merchants.id, merchants.name, SUM(invoice_items.quantity) AS items_sold')
    .order('items_sold DESC')
    .pluck('merchants.id', 'merchants.name', 'SUM(invoice_items.quantity) AS items_sold')
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
    .select('merchants.id, merchants.name, SUM(invoice_items.quantity) AS items_sold')
    .where(transactions: {result: "success"})
    .group('merchants.id')
    .order('items_sold DESC')
    .find(arg).items_sold
  end

  def self.highest_revenue
    result = joins(invoices: [:invoice_items, :transactions])
    .select('merchants.id, merchants.name, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .where('transactions.result = ?', 'success')
    .group('merchants.id')
    .order('total_revenue desc')
    .pluck('merchants.id, merchants.name, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .map do |id, name, revenue|
      {
        id: id.to_s,
        type: 'merchant_name_revenue',
        attributes: {
          name: name,
          revenue: revenue
        }
      }
    end
  end

  def self.merchant_revenue(arg)
    rev = joins(invoices: [:invoice_items, :transactions])
    .select('merchants.id, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .where(transactions: {result: "success"})
    .group('merchants.id')
    .find(arg)
    merch_rev =
      {
        id: rev.id.to_s,
        type: 'merchant_revenue',
        attributes: {
          revenue: rev.total_revenue
        }
      }
  end

  # def this_method
  #   (caller[0][/`([^’]*)’/, 1]).to_s
  # end
end
