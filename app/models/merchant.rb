class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  scope :find_merchant, ->(name) { where('name ILIKE ?', "%#{name}%") }
  scope :items_sold, ->(quantity) { ordered_by_quantity.take(quantity.to_i) }

  def self.ordered_by_quantity
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

  def self.highest_revenue(arg)
    result = joins(invoices: [:invoice_items, :transactions])
    .select('merchants.id, merchants.name, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
    .where('transactions.result = ?', 'success')
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

  # def this_method
  #   (caller[0][/`([^’]*)’/, 1]).to_s
  # end
end
