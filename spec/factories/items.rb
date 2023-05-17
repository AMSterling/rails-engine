FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant #{ create(:merchant) }

    factory :items_with_invoices do
      transient do
        invoice_items_count { 1 }
      end

      after(:create) do |item, evaluator|
        create_list(:invoice_item, evaluator.invoice_items_count, item: item)
      end
    end
  end
end
