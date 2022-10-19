FactoryBot.define do
  factory :invoice do
    status { ['pending', 'packaged', 'shipped'].sample }
    customer { create(:customer) }
    merchant { create(:merchant) }
  end
end
