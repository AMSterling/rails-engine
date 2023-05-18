require 'rails_helper'

RSpec.describe 'Merchants API endpoints' do
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

  describe 'merchant index and show' do
    it 'fetches all merchants' do
      get '/api/v1/merchants'

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchants = response_body[:data]

      expect(merchants.count).to eq(5)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes][:name]).to be_a(String)
        expect(merchant[:attributes]).to_not have_key(:created_at)
      end
    end

    it 'fetches one merchant by its ID' do
      get "/api/v1/merchants/#{merchant1.id}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes][:name]).to be_a(String)

      expect(merchant[:attributes]).to_not have_key(:created_at)
    end

    it 'responds with 404 if no merchant by ID' do
      id = 4_164_616

      get "/api/v1/merchants/#{id}"

      response_body = JSON.parse(response.body, symbolize_names: true)
      response_body[:data]

      expect(response).to have_http_status(404)
    end
  end

  describe 'merchant items' do
    it 'fetches all items from the merchant' do

      get "/api/v1/merchants/#{merchant1.id}/items"

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant_items = response_body[:data]

      expect(response).to be_successful

      merchant_items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item).to have_key(:type)
        expect(item[:type]).to be_a(String)
        expect(item[:type]).to eq('item')

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:attributes]).to_not have_key(:created_at)
      end
    end

    it 'responds with 404 if merchant ID is passed as a string' do
      id = 'merchant_id'

      get "/api/v1/merchants/#{id}/items"

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(response).to have_http_status(404)
      expect(merchant).to eq nil
    end
  end

  describe 'find merchant' do
    it 'fetches first merchant matched by case insensitive name' do
      get "/api/v1/merchants/find?name=#{merchant1.name.to(4)}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant[:id].to_i).to eq(merchant1.id)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant[:attributes][:name].downcase).to include(merchant1.name.to(4).downcase)

      expect(merchant[:attributes]).to_not have_key(:created_at)
    end

    it 'returns a message if no merchant matches search by name' do
      search_name = 'Junk'

      get "/api/v1/merchants/find?name=#{search_name}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(merchant).to eq({ :message => 'Merchant not found' })
    end

    it 'responds with 400 if search by name is empty' do
      search_name = ''

      get "/api/v1/merchants/find?name=#{search_name}"

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)

      response_body = JSON.parse(response.body, symbolize_names: true)
      merchant = response_body[:data]

      expect(merchant).to eq({})
    end
  end

  describe 'find all merchants' do
    context 'when valid' do
      it 'fetches all merchants by name case insensitive' do
        get "/api/v1/merchants/find_all?name=#{merchant1.name.to(4)}"

        expect(response).to be_successful

        response_body = JSON.parse(response.body, symbolize_names: true)
        merchants = response_body[:data]

        merchants.each do |merchant|
          expect(merchant).to have_key(:id)
          expect(merchant[:id]).to be_a(String)

          expect(merchant).to have_key(:attributes)
          expect(merchant[:attributes][:name]).to be_a(String)
          expect(merchant[:attributes][:name]).to include(merchant1.name.to(4))
          expect(merchant[:attributes]).to_not have_key(:created_at)
        end
      end
    end

    context 'when invalid' do
      it 'responds with 404' do
        search_name = 'Junk'

        get "/api/v1/merchants/find_all?name=#{search_name}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)

        response_body = JSON.parse(response.body, symbolize_names: true)
        merchant = response_body[:data]

        expect(merchant).to eq([])
      end

      it 'responds with 404' do
        search_name = ''

        get "/api/v1/merchants/find_all?name=#{search_name}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)
        merchant = response_body[:data]

        expect(merchant).to eq({})
      end
    end
  end

  describe 'most items' do
    context 'when valid quantity' do
      it 'fetches queried number of merchants with most items sold' do
        quantity = 2

        get "/api/v1/merchants/most_items?quantity=#{quantity}"

        expect(response).to be_successful

        response_body = JSON.parse(response.body, symbolize_names: true)
        merchants = response_body[:data]

        expect(merchants.count).to eq(2)

        merchants.each do |merchant|
          expect(merchant).to have_key(:id)
          expect(merchant[:id]).to be_a(String)
          expect(merchant).to have_key(:type)
          expect(merchant[:type]).to be_a(String)
          expect(merchant[:type]).to eq('items_sold')

          expect(merchant).to have_key(:attributes)
          expect(merchant[:attributes]).to have_key(:name)
          expect(merchant[:attributes][:name]).to be_a(String)
          expect(merchant[:attributes]).to have_key(:count)
          expect(merchant[:attributes][:count]).to be_an(Integer)
          expect(merchant[:attributes]).to_not have_key(:created_at)
        end
      end

      # it 'returns 5 merchants when quantity is left blank' do
      #   quantity = ''
      #
      #   get "/api/v1/merchants/most_items?quantity=#{quantity}"
      #
      #   expect(response).to be_successful
      #
      #   response_body = JSON.parse(response.body, symbolize_names: true)
      #   merchants = response_body[:data]
      #
      #   expect(merchants.count).to eq(5)
      #
      #   merchants.each do |merchant|
      #     expect(merchant).to have_key(:id)
      #     expect(merchant[:id]).to be_a(String)
      #     expect(merchant).to have_key(:type)
      #     expect(merchant[:type]).to be_a(String)
      #     expect(merchant[:type]).to eq('items_sold')
      #
      #     expect(merchant).to have_key(:attributes)
      #     expect(merchant[:attributes]).to have_key(:name)
      #     expect(merchant[:attributes][:name]).to be_a(String)
      #     expect(merchant[:attributes]).to have_key(:count)
      #     expect(merchant[:attributes][:count]).to be_an(Integer)
      #     expect(merchant[:attributes]).to_not have_key(:created_at)
      #   end
      # end
    end

    context 'when invalid quantity' do
      it 'responds with 404 for missing parameter' do

        get '/api/v1/merchants/most_items'

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)

        response_body = JSON.parse(response.body, symbolize_names: true)

        expect(response_body).to eq({:data=>[], :error=>"error"})
      end

      it 'responds with 404 for negative integer' do
        quantity = -1

        get "/api/v1/merchants/most_items?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)
      end

      it 'responds with 404 for blank quantity' do
        quantity = ''

        get "/api/v1/merchants/most_items?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)
      end

      it 'responds with 404 for string' do
        quantity = 'amount'

        get "/api/v1/merchants/most_items?quantity=#{quantity}"

        expect(response).to_not be_successful
        expect(response).to have_http_status(400)
      end
    end
  end
end
