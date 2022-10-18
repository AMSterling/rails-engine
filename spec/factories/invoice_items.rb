FactoryBot.define do
  factory :invoice_item do
    item { create(:item) }
    invoice { create(:invoice) }
    quantity { Faker::Number.non_zero_digit }
    unit_price { (item.unit_price * quantity).round(2) }
  end
end
