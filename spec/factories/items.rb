FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant { create(:merchant) }
  end
end
