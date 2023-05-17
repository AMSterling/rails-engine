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

    describe '#most_items_sold' do
      it 'returns specified quantity fo merchants with most items sold' do
        qty = 3
        result = Merchant.most_items_sold(qty)

        expect(result).to be_an Array
        expect(result[0]).to include(id: merchant3.id.to_s)
        expect(result[1]).to include(id: merchant2.id.to_s)
        expect(result[2]).to include(id: merchant1.id.to_s)
        result.each do |merch|
          expect(merch).to be_a Hash
          expect(merch.keys).to eq([:id, :type, :attributes])
          expect(merch[:attributes].keys).to eq([:name, :count])
        end
      end
    end

    describe '#merch_items_sold' do
      it 'returns total number of items sold by a merchant' do
        arg = merchant2.id

        expect(Merchant.merch_items_sold(arg)).to eq(1800)
      end
    end

    describe '#highest_revenue' do
      it 'returns specified quantity fo merchants with highest revenue' do
        qty = 2

        expect(Merchant.highest_revenue(qty)).to eq([
          [merchant3.id, merchant3.name, Merchant.highest_revenue(qty)[0][2]],
          [merchant2.id, merchant2.name, Merchant.highest_revenue(qty)[1][2]]
          ])
      end
    end

    describe '#merchant_revenue' do
      it 'returns total revenue for a merchant' do
        arg = merchant2.id
        total_revenue = (m2ii1.quantity * m2ii1. unit_price) + (m2ii2.quantity * m2ii2. unit_price)
        expect(Merchant.merchant_revenue(arg)).to be_a Float
        expect(Merchant.merchant_revenue(arg)).to eq(total_revenue)
      end
    end
  end
end
