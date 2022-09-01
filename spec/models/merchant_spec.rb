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
    describe '#find_merchant' do
      it 'scopes merchants with fuzzy search by name' do
        create_list(:merchant, 5)

        search = Merchant.first.name
        
        Merchant.find_merchant(search).each do |merchant|
          expect(search).to eq(merchant.name)
        end
      end
    end
  end
end
