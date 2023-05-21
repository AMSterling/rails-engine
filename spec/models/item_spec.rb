require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_a?(Float) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'model methods' do
    let!(:items) { create_list(:item, 5) }
    let!(:item1) { items.first }
    let!(:item2) { items.second }
    let!(:item3) { items.third }
    let!(:item4) { items.fourth }
    let!(:item5) { items.last }
    let!(:invoices) { create_list(:invoice_with_transactions, 3, status: 'shipped') }
    let!(:i1i1) { create(:invoice_item, invoice: invoices[0], item: item1, quantity: 14) }
    let!(:i1i2) { create(:invoice_item, invoice: invoices[0], item: item2, quantity: 50) }
    let!(:i2i1) { create(:invoice_item, invoice: invoices[1], item: item1, quantity: 12) }
    let!(:i2i2) { create(:invoice_item, invoice: invoices[1], item: item3, quantity: 300) }
    let!(:i3i3) { create(:invoice_item, invoice: invoices[2], item: item2, quantity: 70) }
    let!(:i3i2) { create(:invoice_item, invoice: invoices[2], item: item3, quantity: 600) }
    let!(:i3i4) { create(:invoice_item, invoice: invoices[2], item: item4, quantity: 3) }
    let!(:i3i5) { create(:invoice_item, invoice: invoices[2], item: item5, quantity: 2) }

    describe '::filter_by_name' do
      it 'scopes items with fuzzy search by name' do
        name_search = item1.name.to(4)

        Item.filter_by_name(name_search).each do |item|
          expect(item.name.downcase).to include(item1.name.to(4).downcase)
        end
      end

      it 'scopes items with search through description' do
        name_search = item1.description

        Item.filter_by_name(name_search).each do |item|
          expect(item[:attributes][:name]).to eq(item1.name)
        end
      end

      it 'returns empty if no search matches name' do
        name_search = 'Junk'

        Item.filter_by_name(name_search).each do |item|
          expect(name_search).to eq nil
        end
      end
    end

    describe '::filter_by_min_price' do
      it 'scopes items with unit price over specified amount' do
        min_price = 50

        Item.filter_by_min_price(min_price).each do |item|
          expect(item.unit_price).to be >= 50
        end
      end
    end

    describe '::filter_by_max_price' do
      it 'scopes items with unit price under specified amount' do
        max_price = 50

        Item.filter_by_max_price(max_price).each do |item|
          expect(item.unit_price).to be <= 50
        end
      end
    end

    describe '#highest_revenue' do
      it 'returns items in order by higest revenue' do
        qty = 2
        result = Item.highest_revenue(qty)

        expect(result).to be_an Array
        expect(result).to eq([item3, item2])
      end
    end

    describe '.revenue' do
      it 'returns total revenue for an item' do
        item_rev = i3i5.unit_price * i3i5.quantity

        expect(item5.revenue).to eq(item_rev)
      end
    end

    describe '#as_json' do
      it 'assigns instance methods as attribute' do

        expect(item1.to_json).to include('revenue')
      end
    end
  end
end
