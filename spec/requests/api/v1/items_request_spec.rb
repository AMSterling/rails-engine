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

  it "can create a new item" do
    item_params = ({
                    name: Faker::Commerce.product_name,
                    description: Faker::Lorem.paragraph,
                    unit_price: Faker::Number.decimal(l_digits: 2),
                    merchant_id: create(:merchant).id
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end
end
