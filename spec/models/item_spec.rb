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

    describe '#find_item' do
      it 'scopes items with fuzzy search by name' do
        name_search = item1.name[0, 3]

        Item.find_name(name_search).each do |item|
          expect(item.name.downcase).to include(item1.name[0, 3].downcase)
        end
      end

      it 'returns empty if no search matches name' do
        name_search = 'Junk'

        Item.find_name(name_search).each do |item|
          expect(name_search).to eq nil
        end
      end
    end

    describe '#find_min_price' do
      it 'scopes items with unit price over specified amount' do
        min_price = 50

        Item.find_min_price(min_price).each do |item|
          expect(item.unit_price).to be >= 50
        end
      end
    end

    describe '#find_max_price' do
      it 'scopes items with unit price under specified amount' do
        max_price = 50

        Item.find_max_price(max_price).each do |item|
          expect(item.unit_price).to be <= 50
        end
      end
    end
  end
end
