class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
end
