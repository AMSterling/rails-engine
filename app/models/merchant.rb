class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  scope :find_merchant,  -> (name) {where('name ILIKE ?', "%#{name}%")}
end
