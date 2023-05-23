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
    let!(:invoice1) { create(:invoice_with_transactions, status: 'packaged', created_at: 5.days.ago) }
    let!(:invoice2) { create(:invoice_with_transactions, status: 'shipped', created_at: 2.days.ago) }
    let!(:invoice3) { create(:invoice_with_transactions, status: 'shipped', created_at: 7.days.ago) }
    let!(:invoice4) { create(:invoice_with_transactions, status: 'shipped', created_at: 18.days.ago) }
    let!(:invoice5) { create(:invoice_with_transactions, status: 'packaged', created_at: 9.days.ago) }
    let!(:items) { create_list(:item, 3) }
    let!(:item1) { items.first }
    let!(:item2) { items.second }
    let!(:item3) { items.third }
    let!(:invoice_item1) { create(:invoice_item, item: item1, invoice: invoice1, quantity: 50) }
    let!(:invoice_item2) { create(:invoice_item, item: item2, invoice: invoice1) }
    let!(:invoice_item3) { create(:invoice_item, item: item1, invoice: invoice2) }
    let!(:invoice_item4) { create(:invoice_item, item: item2, invoice: invoice2) }
    let!(:invoice_item5) { create(:invoice_item, item: item3, invoice: invoice2) }
    let!(:invoice_item6) { create(:invoice_item, item: item3, invoice: invoice3) }
    let!(:invoice_item7) { create(:invoice_item, item: item3, invoice: invoice4) }
    let!(:invoice_item8) { create(:invoice_item, item: item2, invoice: invoice5, quantity: 3) }

    describe '#delete_empty_invoice' do
      it 'deletes invoices if only item is delted' do

        expect(Invoice.count).to eq 5
        expect(item3.invoices.delete_empty_invoice).to eq([invoice3, invoice4])
        expect(Invoice.count).to eq 3
        expect(item2.invoices.delete_empty_invoice).to eq([invoice5])
        expect(Invoice.count).to eq 2
      end
    end

    describe '#total_revenue' do
      it 'returns all revenue' do
        start_date = Date.today.days_ago(20).strftime('%F')
        end_date = Date.today.days_ago(6).strftime('%F')
        result = Invoice.total_revenue(start_date, end_date)
        total_revenue =
        (invoice_item6.unit_price * invoice_item6.quantity) +
        (invoice_item7.unit_price * invoice_item7.quantity)

        expect(result).to eq(total_revenue)
      end
    end

    describe '#unshipped_order' do
      it 'returns a quantity of unshipped invoices' do
        qty = 2
        results = Invoice.unshipped_order(qty)

        expect(results).to eq([invoice1, invoice5])
        results.each do |result|

          expect(result.attributes.keys).to eq(['id', 'potential_revenue'])
          expect(result.id).to be_an Integer
          expect(result.potential_revenue).to be_a Float
        end
      end
    end

    describe '#weekly_revenue' do
      it 'returns total revenue truncated by week' do
        results = Invoice.weekly_revenue

        results.each do |result|
          expect(result.attributes.keys).to eq(['id', 'week', 'revenue'])
          expect(result.id).to be_nil
          expect(result.week).to be_a Time
          expect(result.revenue).to be_a Float
        end
      end
    end
  end
end
