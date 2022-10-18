class Item < ApplicationRecord
  validates_presence_of :name, :unit_price
  validates_presence_of :description
  validates_numericality_of :unit_price, only_float: true, greater_than_or_equal_to: 0
  validates_presence_of :merchant_id

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  scope :find_name,  -> (name) { where(['name ILIKE ?', "%#{name}%"]) }
  scope :find_min_price, -> (min_price) { where('unit_price >= ?', min_price) }
  scope :find_max_price, -> (max_price) { where('unit_price <= ?', max_price) }
  # scope :min_max_price, -> (min_price, max_price) { where("unit_price >= :min_price AND unit_price <= :max_price", "%#{min_price}%", "%#{max_price}%") }
end
