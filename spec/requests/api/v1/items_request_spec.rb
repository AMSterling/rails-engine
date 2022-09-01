require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    create_list(:item, 5)

    get '/api/v1/items'

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

    expect(response).to be_successful

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

  it 'can get one merchant by its ID' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

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

  it "can create a new item then delete it" do
    item_params = ({
                    name: Faker::Commerce.product_name,
                    description: Faker::Lorem.paragraph,
                    unit_price: Faker::Number.decimal(l_digits: 2),
                    merchant_id: create(:merchant).id
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to have_http_status(201)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])

    delete "/api/v1/items/#{created_item.id}"

    expect(response).to have_http_status(204)
    expect(Item.count).to eq(0)
    expect{Item.find(created_item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can update an existing item" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: Faker::Commerce.product_name }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq(item.name)
  end

  it 'returns 404 if item cannot be found' do
    merchant = create(:merchant)
    id = 90654501

    get "/api/v1/items/#{id}"

    expect(response).to have_http_status(404)

    delete "/api/v1/items/#{id}"

    expect(response).to have_http_status(404)
  end

  it 'returns 404 if item cannot be created' do
    merchant = create(:merchant)
    item_params = ({
                    name: Faker::Commerce.product_name,
                    description: Faker::Lorem.paragraph,
                    unit_price: Faker::Lorem.paragraph,
                    merchant_id: merchant.id
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to have_http_status(404)
  end

  it 'returns 404 if item cannot be updated' do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: Faker::Commerce.product_name, merchant_id: 92048440 }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to have_http_status(404)
  end

  it 'can return the items merchant' do
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
end
