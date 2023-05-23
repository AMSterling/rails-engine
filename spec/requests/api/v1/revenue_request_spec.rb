require 'rails_helper'

RSpec.describe 'Revenue API endpoints' do
  let!(:merchants) { create_list(:merchant_with_items, 5) }
  let!(:merchant1) { merchants.first }
  let!(:merchant2) { merchants.second }
  let!(:merchant3) { merchants.third }
  let!(:merchant4) { merchants.fourth }
  let!(:merchant5) { merchants.fifth }
  let!(:m1_invoice) { create(:invoice_with_transactions, merchant: merchant1, status: 'packaged', created_at: 5.days.ago) }
  let!(:m2_invoice) { create(:invoice_with_transactions, merchant: merchant2, status: 'shipped', created_at: 2.days.ago) }
  let!(:m3_invoice) { create(:invoice_with_transactions, merchant: merchant3, status: 'shipped', created_at: 8.days.ago) }
  let!(:m4_invoice) { create(:invoice_with_transactions, merchant: merchant4, status: 'shipped', created_at: 18.days.ago) }
  let!(:m5_invoice) { create(:invoice_with_transactions, merchant: merchant5, status: 'packaged', created_at: 9.days.ago) }
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

        expect(response_body).to eq({:error=>"Couldn't find Merchant with 'id'=4164616"})
      end
    end
  end

  describe 'total revenue' do
    context 'valid start and end dates' do
      it 'fetches total revenue within a date range' do
        start_date = Date.today.days_ago(20).strftime('%F')
        end_date = Date.today.days_ago(6).strftime('%F')

        get "/api/v1/revenue?start=#{start_date}&end=#{end_date}"

        expect(response).to be_successful

        response_body = JSON.parse(response.body, symbolize_names: true)
        revenue = response_body[:data]

        expect(revenue).to have_key(:id)
        expect(revenue[:id]).to be_nil
        expect(revenue).to have_key(:attributes)
        expect(revenue[:attributes]).to have_key(:revenue)
        expect(revenue[:attributes][:revenue]).to be_a Float
      end
    end

    context 'invalid start and end dates' do
      it 'responds with 400 if dates are blank' do
        start_date = ''
        end_date = ''

        get "/api/v1/revenue?start=#{start_date}&end=#{end_date}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>{}, :error=>"error"})
      end

      it 'responds with 400 if dates are missing' do

        get '/api/v1/revenue'

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>{}, :error=>"error"})
      end

      it 'responds with 400 if any date is missing' do
        start_date = ''
        end_date = Date.today.days_ago(6).strftime('%F')

        get "/api/v1/revenue?start=#{start_date}&end=#{end_date}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>{}, :error=>"error"})
      end
    end
  end

  describe 'item revenue' do
    context 'when valid quantity' do
      it 'fetches items by highest revenue' do
        quantity = 2

        get "/api/v1/revenue/items?quantity=#{quantity}"

        expect(response).to be_successful

        response_body = JSON.parse(response.body, symbolize_names: true)
        items = response_body[:data]

        expect(items.count).to eq(2)
        items.each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_a(String)
          expect(item).to have_key(:type)
          expect(item[:type]).to be_a(String)
          expect(item[:type]).to eq('item_revenue')

          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_a(String)
          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description]).to be_a(String)
          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be_a(Float)
          expect(item[:attributes]).to have_key(:merchant_id)
          expect(item[:attributes][:merchant_id]).to be_an(Integer)
          expect(item[:attributes]).to have_key(:revenue)
          expect(item[:attributes][:revenue]).to be_a(Float)
          expect(item[:attributes]).to_not have_key(:created_at)
        end
      end
    end

    context 'when invalid quantity' do
      it 'responds with 404 for missing parameter' do

        get '/api/v1/revenue/items'

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>[], :error=>"error"})
      end

      it 'responds with 404 for negative integer' do
        quantity = -1

        get "/api/v1/revenue/items?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>{}})
      end

      it 'responds with 404 for blank quantity' do
        quantity = ''

        get "/api/v1/revenue/items?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>[], :error=>"error"})
      end

      it 'responds with 404 for string' do
        quantity = 'amount'

        get "/api/v1/revenue/items?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>{}})
      end
    end
  end

  describe 'potential revenue' do
    context 'when valid quantity' do
      it 'fetches quantity of unshipped invoices' do
        quantity = 2

        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        expect(response).to be_successful

        response_body = JSON.parse(response.body, symbolize_names: true)
        invoices = response_body[:data]

        expect(invoices.count).to eq(2)
        invoices.each do |invoice|
          expect(invoice).to have_key(:id)
          expect(invoice[:id]).to be_a(String)
          expect(invoice).to have_key(:type)
          expect(invoice[:type]).to be_a(String)
          expect(invoice[:type]).to eq('unshipped_order')

          expect(invoice).to have_key(:attributes)
          expect(invoice[:attributes]).to have_key(:potential_revenue)
          expect(invoice[:attributes][:potential_revenue]).to be_a(Float)
          expect(invoice[:attributes]).to_not have_key(:created_at)
        end
      end
    end

    context 'when invalid quantity' do
      it 'responds with 404 for missing parameter' do

        get '/api/v1/revenue/unshipped'

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>[], :error=>"error"})
      end

      it 'responds with 404 for negative integer' do
        quantity = -1

        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>{}})
      end

      it 'responds with 404 for blank quantity' do
        quantity = ''

        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>[], :error=>"error"})
      end

      it 'responds with 404 for string' do
        quantity = 'amount'

        get "/api/v1/revenue/unshipped?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>{}})
      end
    end
  end

  describe 'weekly revenue' do
    it 'fetches a report of all revenue by week' do

      get '/api/v1/revenue/weekly'

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      weeks = response_body[:data]

      expect(weeks).to be_an Array
      expect(weeks.count).to eq 2
      weeks.each do |week|
        expect(week).to have_key(:id)
        expect(week[:id]).to be_nil
        expect(week).to have_key(:type)
        expect(week[:type]).to eq('weekly_revenue')
        expect(week).to have_key(:attributes)
        expect(week[:attributes]).to be_a Hash
        expect(week[:attributes]).to have_key(:week)
        expect(week[:attributes][:week]) =~ (/\d{4}\-\d{2}\-\d{2}/)
        expect(week[:attributes]).to have_key(:revenue)
        expect(week[:attributes][:revenue]).to be_a Float
      end
    end
  end
end
