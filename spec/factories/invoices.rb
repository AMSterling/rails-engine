FactoryBot.define do
  factory :invoice do
    status { %w[packaged shipped returned].sample }
    customer { create(:customer) }
    merchant # { create(:merchant) }

    factory :invoice_with_transactions do
      transient do
        transactions_count { 1 }
      end

      after(:create) do |invoice, evaluator|
        create_list(:transaction, evaluator.transactions_count, result: 'success', invoice: invoice)
      end
    end
  end
end
