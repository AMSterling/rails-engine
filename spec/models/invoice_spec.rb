require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should belong_to(:merchant) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'class methods' do
    let!(:invoices) { create_list(:invoice, 5) }
    let!(:invoice1) { invoices.first }
    let!(:invoice2) { invoices.second }
    let!(:invoice3) { invoices.third }
    let!(:invoice4) { invoices.fourth }
    let!(:invoice5) { invoices.fifth }
    let!(:items) { create_list(:item, 3) }
    let!(:item1) { items.first }
    let!(:item2) { items.second }
    let!(:item3) { items.third }
    let!(:invoice_item1) { create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id) }
    let!(:invoice_item2) { create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id) }
    let!(:invoice_item3) { create(:invoice_item, item_id: item1.id, invoice_id: invoice2.id) }
    let!(:invoice_item4) { create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id) }
    let!(:invoice_item5) { create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id) }
    let!(:invoice_item6) { create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id) }
    let!(:invoice_item7) { create(:invoice_item, item_id: item3.id, invoice_id: invoice4.id) }
    let!(:invoice_item8) { create(:invoice_item, item_id: item2.id, invoice_id: invoice5.id) }

    it '#delete_empty_invoice' do

      expect(Invoice.count).to eq 5
      expect(item3.invoices.delete_empty_invoice).to eq([invoice3, invoice4])
      expect(Invoice.count).to eq 3
      expect(item2.invoices.delete_empty_invoice).to eq([invoice5])
      expect(Invoice.count).to eq 2
    end
  end
end
