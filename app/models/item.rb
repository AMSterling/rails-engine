class Item < ApplicationRecord
  validates_presence_of :name, :unit_price
  validates_presence_of :description
  validates :unit_price, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates_presence_of :merchant_id

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy

  scope :find_name,  -> (name) { where(['name ILIKE ? OR description = ?', "%#{name}%", "%#{name}%"]) }
  scope :find_min_price, -> (min_price) { where('unit_price >= ?', min_price).order(:name) }
  scope :find_max_price, -> (max_price) { where('unit_price <= ?', max_price).order(:name) }
  # scope :min_max_price, -> (min_price = 0, max_price=Float::INFINITY) { where("unit_price >= ? AND unit_price <= ?", min_price, max_price).order(:name) }
end
