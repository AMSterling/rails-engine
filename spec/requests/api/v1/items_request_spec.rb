require 'rails_helper'

describe 'Items API' do
  # let!(:items) { create_list(:item, 5) }
  # let!(:item1) { items.first }
  # let!(:item2) { items.second }
  # let!(:item3) { items.third }
  # let!(:item4) { items.fourth }
  # let!(:item5) { items.fifth }

  let!(:invoice_items) { create_list(:invoice_item, 5) }
  let!(:item1) { invoice_items.first.item }
  let!(:item2) { invoice_items.second.item }
  let!(:item3) { invoice_items.third.item }
  let!(:item4) { invoice_items.fourth.item }
  let!(:item5) { invoice_items.fifth.item }

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

  it 'can get one item by its ID' do
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
    expect(Item.count).to eq(6)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])

    delete "/api/v1/items/#{created_item.id}"

    expect(response).to have_http_status(204)
    expect(Item.count).to eq(5)
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
    expect(item_params[:name]).to eq(item.name)
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

  it 'can destroy an item' do
    delete "/api/v1/items/#{item5.id}"

    expect(response).to have_http_status(204)
    expect(Item.count).to eq(4)
    expect(InvoiceItem.count).to eq(4)
    expect{Item.find(item5.id)}.to raise_error(ActiveRecord::RecordNotFound)
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

  it 'can find all items by name case insensitive' do
    get "/api/v1/items/find_all?name=#{item1.name[0, 3]}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:name]).to start_with(item1.name[0, 3])
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
  end

  it 'returns 404 if search by name is empty' do
    search_name = ''

    get "/api/v1/items/find_all?name=#{search_name}"

    expect(response).to_not be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]

    expect(item).to eq({})
  end

  it 'can search for an item by name' do
    get "/api/v1/items/find?name=#{item1.name[0, 3]}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)
    expect(item[:id].to_i).to eq(item1.id)
    expect(item).to have_key(:type)
    expect(item[:attributes][:name]).to start_with(item1.name[0, 3])
  end

  it 'returns one item over a given price' do
    min_price = 50
    max_price = 150

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
    min_price = 200000

    get "/api/v1/items/find?min_price=#{min_price}"
    #
    # expect(response).to have_http_status(400)
    #
    # response_body = JSON.parse(response.body, symbolize_names: true)
    # item = response_body[:data]
    #
    # expect(item).to eq({:error => 'error'})
  end

  it 'returns first item under max price' do
    min_price = 50
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
end
