require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'model methods' do
    let!(:merchants) { create_list(:merchant_with_items, 5) }
    let!(:merchant1) { merchants.first }
    let!(:merchant2) { merchants.second }
    let!(:merchant3) { merchants.third }
    let!(:merchant4) { merchants.fourth }
    let!(:merchant5) { merchants.fifth }
    let!(:m1_invoice) { create(:invoice_with_transactions, merchant: merchant1) }
    let!(:m2_invoice) { create(:invoice_with_transactions, merchant: merchant2) }
    let!(:m3_invoice) { create(:invoice_with_transactions, merchant: merchant3) }
    let!(:m4_invoice) { create(:invoice_with_transactions, merchant: merchant4) }
    let!(:m5_invoice) { create(:invoice_with_transactions, merchant: merchant5) }
    let!(:m1ii1) { create(:invoice_item, invoice: m1_invoice, item: merchant1.items[0], quantity: 10) }
    let!(:m2ii1) { create(:invoice_item, invoice: m2_invoice, item: merchant2.items[0], quantity: 1000) }
    let!(:m2ii2) { create(:invoice_item, invoice: m2_invoice, item: merchant2.items[2], quantity: 800) }
    let!(:m3ii1) { create(:invoice_item, invoice: m3_invoice, item: merchant3.items[0], quantity: 6000) }
    let!(:m3ii2) { create(:invoice_item, invoice: m3_invoice, item: merchant3.items[1], quantity: 4000) }
    let!(:m4ii1) { create(:invoice_item, invoice: m4_invoice, item: merchant4.items[0], quantity: 1) }

    describe '::find_merchant' do
      it 'scopes merchants with fuzzy search by name' do
        name_search = merchant1.name.to(4)

        Merchant.find_merchant(name_search).each do |merchant|
          expect(merchant.name.downcase).to include(merchant1.name.to(4).downcase)
        end
      end

      it 'returns empty if no search matches name' do
        name_search = 'Junk'

        Merchant.find_merchant(name_search).each do |merchant|
          expect(name_search).to eq nil
        end
      end
    end

    describe '#items_sold' do
      it 'scopes specified quantity of merchants with most items sold' do
        qty = 3
        results = Merchant.items_sold(qty)

        expect(results).to be_an Array
        expect(results.count).to eq 3
        expect(results).to eq([merchant3, merchant2, merchant1])
        expect(results).to_not include(merchant4)
        expect(results).to_not include(merchant5)
        results.each do |result|
          expect(result.attributes.keys).to eq(['id', 'name', 'created_at', 'updated_at', 'count'])
          expect(result.id).to be_an Integer
          expect(result.name).to be_a String
          expect(result.count).to be_an Integer
        end
      end
    end

    describe '#highest_revenue' do
      it 'orders merchants by highest revenue' do
        qty = 4
        results = Merchant.highest_revenue(qty)

        expect(results).to be_an Array
        expect(results.count).to eq 4
        expect(results).to eq([merchant3, merchant2, merchant1, merchant4])
        expect(results).to_not include(merchant5)
        results.each do |result|
          expect(result.attributes.keys).to eq(['id', 'name', 'created_at', 'updated_at', 'revenue'])
          expect(result.id).to be_an Integer
          expect(result.name).to be_a String
          expect(result.revenue).to be_a Float
        end
      end
    end

    describe '.revenue' do
      it 'returns total revenue for a merchant' do
        total_revenue = (m2ii1.quantity * m2ii1. unit_price) + (m2ii2.quantity * m2ii2. unit_price)

        expect(merchant2.revenue).to eq(total_revenue)
      end
    end

    describe '#as_json' do
      it 'assigns instance methods as attribute' do

        expect(merchant1.to_json).to include('revenue')
      end
    end
  end
end
