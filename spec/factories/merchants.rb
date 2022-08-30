FactoryBot.define do
  factory :merchant do
    name { Faker::Commerce.vendor }
  end
end
