require 'rails_helper'

RSpec.describe 'Revenue API endpoints' do
  let!(:merchants) { create_list(:merchant_with_items, 5) }
  let!(:merchant1) { merchants.first }
  let!(:merchant2) { merchants.second }
  let!(:merchant3) { merchants.third }
  let!(:merchant4) { merchants.fourth }
  let!(:merchant5) { merchants.fifth }
  let!(:m1_invoice) { create(:invoice_with_transactions, transactions_count: 2, merchant: merchant1, status: 'shipped') }
  let!(:m2_invoice) { create(:invoice_with_transactions, transactions_count: 2, merchant: merchant2, status: 'shipped') }
  let!(:m3_invoice) { create(:invoice_with_transactions, merchant: merchant3, status: 'shipped') }
  let!(:m4_invoice) { create(:invoice_with_transactions, merchant: merchant4, status: 'shipped') }
  let!(:m5_invoice) { create(:invoice_with_transactions, merchant: merchant5) }
  let!(:m1ii1) { create(:invoice_item, invoice: m1_invoice, item: merchant1.items[0], quantity: 6000) }
  let!(:m1ii2) { create(:invoice_item, invoice: m1_invoice, item: merchant1.items[1], quantity: 4000) }
  let!(:m2ii1) { create(:invoice_item, invoice: m2_invoice, item: merchant2.items[0], quantity: 1000) }
  let!(:m2ii2) { create(:invoice_item, invoice: m2_invoice, item: merchant2.items[2], quantity: 800) }
  let!(:m3ii1) { create(:invoice_item, invoice: m3_invoice, item: merchant3.items[0], quantity: 10) }
  let!(:m4ii1) { create(:invoice_item, invoice: m4_invoice, item: merchant4.items[0], quantity: 1) }
  let!(:m5ii1) { create(:invoice_item, invoice: m5_invoice, item: merchant5.items[4], quantity: 0) }

  describe 'merchants revenue' do
    context 'when valid quantity' do
      it 'fetches queried number of merchants with most revenue' do
        quantity = 2

        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        expect(response).to be_successful

        response_body = JSON.parse(response.body, symbolize_names: true)
        merchants = response_body[:data]

        expect(merchants.count).to eq(2)
        merchants.each do |merchant|
          expect(merchant).to have_key(:id)
          expect(merchant[:id]).to be_a(String)
          expect(merchant).to have_key(:type)
          expect(merchant[:type]).to be_a(String)
          expect(merchant[:type]).to eq('merchant_name_revenue')

          expect(merchant).to have_key(:attributes)
          expect(merchant[:attributes]).to have_key(:name)
          expect(merchant[:attributes][:name]).to be_a(String)
          expect(merchant[:attributes]).to have_key(:revenue)
          expect(merchant[:attributes][:revenue]).to be_a(Float)
          expect(merchant[:attributes]).to_not have_key(:created_at)
        end
      end
    end

    context 'when invalid quantity' do
      it 'responds with 404 for missing parameter' do

        get '/api/v1/revenue/merchants'

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>[], :error=>"error"})
      end

      it 'responds with 404 for negative integer' do
        quantity = -1

        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)
      end

      it 'responds with 404 for blank quantity' do
        quantity = ''

        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)
      end

      it 'responds with 404 for string' do
        quantity = 'amount'

        get "/api/v1/revenue/merchants?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)
      end
    end

    context 'valid ID' do
      it 'fetches total revenue for a single merchant' do

        get "/api/v1/revenue/merchants/#{merchant4.id}"

        expect(response).to be_successful

        response_body = JSON.parse(response.body, symbolize_names: true)
        merchant = response_body[:data]

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
        expect(merchant[:id]).to eq(merchant4.id.to_s)
        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to be_a(String)
        expect(merchant[:type]).to eq('merchant_revenue')

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to_not have_key(:name)
        expect(merchant[:attributes]).to have_key(:revenue)
        expect(merchant[:attributes][:revenue]).to be_a(Float)
        expect(merchant[:attributes]).to_not have_key(:created_at)
      end
    end

    context 'invalid ID' do
      it 'responds with 404 if no merchant by ID' do
        id = 4_164_616

        get "/api/v1/revenue/merchants/#{id}"

        expect(response).to have_http_status(404)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({ status: 'Not Found' })
      end
    end
  end
end
