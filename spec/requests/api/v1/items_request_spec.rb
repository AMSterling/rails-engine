require 'rails_helper'

RSpec.describe 'Items API endpoints' do
  let!(:invoices) { create_list(:invoice, 3) }
  let!(:invoice1) { invoices.first }
  let!(:invoice2) { invoices.second }
  let!(:invoice3) { invoices.third }
  let!(:items) { create_list(:item, 5) }
  let!(:item1) { items.first }
  let!(:item2) { items.second }
  let!(:item3) { items.third }
  let!(:item4) { items.fourth }
  let!(:item5) { items.fifth }
  let!(:invoice_item1) { create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id) }
  let!(:invoice_item2) { create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id) }
  let!(:invoice_item3) { create(:invoice_item, item_id: item1.id, invoice_id: invoice2.id) }
  let!(:invoice_item4) { create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id) }
  let!(:invoice_item5) { create(:invoice_item, item_id: item3.id, invoice_id: invoice2.id) }
  let!(:invoice_item6) { create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id) }

  describe 'item CRUD' do
    it 'sends a list of items' do
      get '/api/v1/items'

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item).to have_key(:attributes)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:attributes]).to_not have_key(:created_at)
      end
    end

    it 'fetches one item by ID' do
      get "/api/v1/items/#{item1.id}"

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(response).to be_successful

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes]).to_not have_key(:created_at)
    end

    it 'creates a new item then deletes it' do
      item_params = {
                        name: Faker::Commerce.product_name,
                        description: Faker::Lorem.paragraph,
                        unit_price: Faker::Number.decimal(l_digits: 2),
                        merchant_id: create(:merchant).id
                    }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to have_http_status(201)
      expect(Item.count).to eq(12)
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])

      delete "/api/v1/items/#{created_item.id}"

      expect(response).to have_http_status(204)
      expect(Item.count).to eq(11)
      expect { Item.find(created_item.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'updates an existing item' do
      id = create(:item).id
      previous_name = Item.last.name
      item_params = { name: Faker::Commerce.product_name }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item_params[:name]).to eq(item.name)
    end

    it 'returns 404 if item cannot be found' do
      id = 90_654_501

      get "/api/v1/items/#{id}"

      expect(response).to have_http_status(404)
      expect { Item.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns 404 if item cannot be created' do
      item_params = {
                        name: Faker::Commerce.product_name,
                        description: Faker::Lorem.paragraph,
                        unit_price: Faker::Lorem.paragraph,
                        merchant_id: create(:merchant).id
                   }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(404)
    end

    it 'returns 404 if item cannot be updated' do
      id = create(:item).id
      Item.last.name

      item_params = { name: Faker::Commerce.product_name, merchant_id: 92_048_440 }
      headers = { 'CONTENT_TYPE' => 'application/json' }

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
      Item.find_by(id: id)

      expect(response).to have_http_status(404)
    end

    it 'destroys the invoice if only item on invoice is deleted' do
      get '/api/v1/items'

      expect(response).to be_successful
      expect(Item.count).to eq(11)

      delete "/api/v1/items/#{item3.id}"

      expect(response).to have_http_status(204)
      expect(Item.count).to eq(10)
      expect { Item.find(item3.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { InvoiceItem.find(invoice_item6.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Invoice.find(invoice3.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(Invoice.exists?(invoice2.id)).to eq true

      delete "/api/v1/items/#{item3.id}"

      expect(response).to have_http_status(404)
    end

    it 'cannot destroy an item that does not exist' do
      id = 14_564_614

      delete "/api/v1/items/#{id}"

      expect(response).to have_http_status(404)
      expect { Item.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  it 'returns an items merchant' do
    id = create(:merchant).id
    item = create(:item, merchant_id: id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_a(String)

    expect(merchant[:attributes]).to_not have_key(:created_at)
  end

  describe 'find one item' do
    it 'can fetch first item matching partial name' do
      get "/api/v1/items/find?name=#{item1.name.to(4)}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item).to have_key(:type)
      expect(item[:attributes][:name].downcase).to include(item1.name.to(4).downcase)
    end

    it 'returns 400 if find by name is empty' do
      search_name = ''

      get "/api/v1/items/find?name=#{search_name}"

      expect(response).to_not be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to eq({})
    end

    it 'can fetch one item by min price' do
      min_price = 50

      get "/api/v1/items/find?min_price=#{min_price}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:unit_price]).to be >= 50
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes]).to_not have_key(:created_at)
    end

    it 'returns error when min price is so big nothing matches' do
      min_price = 500_000_000

      get "/api/v1/items/find?min_price=#{min_price}"

      expect(response).to have_http_status(400)

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to eq({})
    end

    it 'returns an error if min price is negative amount' do
      min_price = -5

      get "/api/v1/items/find?min_price=#{min_price}"

      expect(response).to have_http_status(400)

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to eq({})
    end

    it 'can fetch one item by max price' do
      max_price = 150

      get "/api/v1/items/find?max_price=#{max_price}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:unit_price]).to be <= 150
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes]).to_not have_key(:created_at)
    end

    it 'returns error when max price is so small nothing matches' do
      max_price = 0.30

      get "/api/v1/items/find?max_price=#{max_price}"

      expect(response).to have_http_status(400)

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to eq({})
    end

    it 'returns an error if max price is negative amount' do
      max_price = -5

      get "/api/v1/items/find?max_price=#{max_price}"

      expect(response).to have_http_status(400)

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to eq({})
    end

    it 'returns an item within price range' do
      min_price = 50
      max_price = 150

      get "/api/v1/items/find?min_price=#{min_price}&max_price=#{max_price}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:unit_price]).to be >= 50
      expect(item[:attributes][:unit_price]).to be <= 150
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:attributes]).to_not have_key(:created_at)
    end

    it 'returns an error if min price is greater than max price' do
      min_price = 50
      max_price = 5

      get "/api/v1/items/find?min_price=#{min_price}&max_price=#{max_price}"

      expect(response).to have_http_status(400)

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to eq({})
    end

    it 'cannot search by name and min price' do
      min_price = 50

      get "/api/v1/items/find?name=#{item1.name.to(4)}&min_price=#{min_price}"

      expect(response).to have_http_status(400)
    end

    it 'cannot search by name and max price' do
      max_price = 150

      get "/api/v1/items/find?name=#{item1.name.to(4)}&max_price=#{max_price}"

      expect(response).to have_http_status(400)
    end
  end

  describe 'find all items' do
    it 'can find all items by name case insensitive' do
      get "/api/v1/items/find_all?name=#{item1.name.to(4)}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item).to have_key(:attributes)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:name].downcase).to include(item1.name.to(4).downcase)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:attributes]).to_not have_key(:created_at)
      end
    end

    it 'returns 400 if no item matches search by name' do
      search_name = 'Junk'

      get "/api/v1/items/find_all?name=#{search_name}"

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      expect(items).to eq([])
    end

    it 'returns 400 if find all by name is empty' do
      search_name = ''

      get "/api/v1/items/find_all?name=#{search_name}"

      expect(response).to_not be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      expect(items).to eq([])
    end

    it 'can fetch all items by min price' do
      min_price = 50

      get "/api/v1/items/find_all?min_price=#{min_price}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item).to have_key(:attributes)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:unit_price]).to be >= 50
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:attributes]).to_not have_key(:created_at)
      end
    end

    it 'returns error if find all by min price is empty' do
      min_price = ''

      get "/api/v1/items/find_all?min_price=#{min_price}"

      expect(response).to_not be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      expect(items).to eq([])
    end

    it 'can fetch all items by max price' do
      max_price = 150

      get "/api/v1/items/find_all?max_price=#{max_price}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item).to have_key(:attributes)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:unit_price]).to be <= 150
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:attributes]).to_not have_key(:created_at)
      end
    end

    it 'returns error if find all by max price is empty' do
      max_price = ''

      get "/api/v1/items/find_all?max_price=#{max_price}"

      expect(response).to_not be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      expect(items).to eq([])
    end

    it 'returns all items within price range' do
      min_price = 5
      max_price = 150

      get "/api/v1/items/find_all?min_price=#{min_price}&max_price=#{max_price}"

      expect(response).to be_successful

      response_body = JSON.parse(response.body, symbolize_names: true)
      items = response_body[:data]

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item).to have_key(:attributes)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:unit_price]).to be >= 5
        expect(item[:attributes][:unit_price]).to be <= 150
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:attributes]).to_not have_key(:created_at)
      end
    end

    it 'returns an error if min price is greater than max price' do
      min_price = 50
      max_price = 5

      get "/api/v1/items/find_all?min_price=#{min_price}&max_price=#{max_price}"

      expect(response).to have_http_status(400)

      response_body = JSON.parse(response.body, symbolize_names: true)
      item = response_body[:data]

      expect(item).to eq([])
    end

    it 'cannot search by name and min price' do
      min_price = 50

      get "/api/v1/items/find_all?name=#{item1.name.to(4)}&min_price=#{min_price}"

      expect(response).to have_http_status(400)
    end

    it 'cannot search by name and max price' do
      max_price = 150

      get "/api/v1/items/find_all?name=#{item1.name.to(4)}&max_price=#{max_price}"

      expect(response).to have_http_status(400)
    end
  end
end
