class Item < ApplicationRecord
  include Filterable

  validates :name, :unit_price, :description, :merchant_id, presence: true
  validates :unit_price, numericality: { greater_than_or_equal_to: 0, only_float: true }

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy

  scope :filter_by_name, ->(name) { where(['name ILIKE ? OR description = ?', "%#{name}%", "%#{name}%"]) }
  scope :filter_by_min_price, ->(min_price) { where('unit_price >= ?', min_price).order(:name) }
  scope :filter_by_max_price, ->(max_price) { where('unit_price <= ?', max_price).order(:name) }
  # scope :filter_by_min_max_price, -> (min_price = 0, max_price=Float::INFINITY) { where("unit_price >= ? AND unit_price <= ?", min_price, max_price).order(:name) }
end
