FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Business.credit_card_number }
    credit_card_expiration_date { ['11/27', '08/26', '05/29'].sample }
    status { ['failed', 'success'].sample }
    invoice { create(:invoice) }
  end
end
