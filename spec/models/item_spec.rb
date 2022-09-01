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
    describe '#find_item' do
      it 'scopes items with fuzzy search by name' do
        create_list(:item, 5)

        name_search = Item.first.name

        Item.find_item(name_search).each do |item|
          expect(name_search).to eq(item.name)
        end
      end

      it 'returns empty if no search matches name' do
        create_list(:item, 5)

        name_search = 'Junk'

        Item.find_item(name_search).each do |item|
          expect(name_search).to eq nil
        end
      end
    end
  end
end
