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
    let!(:merchants) { create_list(:merchant, 5) }
    let!(:merchant1) { merchants.first }
    let!(:merchant2) { merchants.second }
    let!(:merchant3) { merchants.third }
    let!(:merchant4) { merchants.fourth }
    let!(:merchant5) { merchants.fifth }

    describe '#find_merchant' do
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
  end
end
