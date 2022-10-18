FactoryBot.define do
  factory :invoice do
    status { ['pending', 'completed'].sample }
    customer { create(:customer) }
    merchant { create(:merchant) }
  end
end
