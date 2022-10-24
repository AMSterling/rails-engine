FactoryBot.define do
  factory :invoice do
    status { %w[pending packaged shipped].sample }
    customer { create(:customer) }
    merchant { create(:merchant) }
  end
end
