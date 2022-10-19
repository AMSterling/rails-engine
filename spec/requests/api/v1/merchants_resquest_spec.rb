require 'rails_helper'

describe 'Merchants API' do
  let!(:merchants) { create_list(:merchant, 5) }
  let!(:merchant1) { merchants.first }
  let!(:merchant2) { merchants.second }
  let!(:merchant3) { merchants.third }
  let!(:merchant4) { merchants.fourth }
  let!(:merchant5) { merchants.fifth }

  it 'sends a list of all merchants' do
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

  it 'can get one merchant by its ID' do
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

  it 'returns error if no merchant by ID' do
    id = 4164616

    get "/api/v1/merchants/#{id}"

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]

    expect(response).to have_http_status(404)
  end

  it 'returns all items from the merchant' do
    create_list(:item, 5, merchant_id: merchant1.id)

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

  it 'can find first merchant matched by case insensitive name' do
    get "/api/v1/merchants/find?name=#{merchant1.name[0, 3]}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)
    expect(merchant[:id].to_i).to eq(merchant1.id)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_a(String)
    expect(merchant[:attributes][:name].downcase).to include(merchant1.name[0, 3].downcase)

    expect(merchant[:attributes]).to_not have_key(:created_at)
  end

  it 'returns a message if no merchant matches search by name' do
    search_name = 'Junk'

    get "/api/v1/merchants/find?name=#{search_name}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]

    expect(merchant).to eq({:message => 'Merchant not found'})
  end

  it 'returns 404 if search by name is empty' do
    search_name = ''

    get "/api/v1/merchants/find?name=#{search_name}"

    expect(response).to_not be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]

    expect(merchant).to eq({})
  end

  it 'can find all merchants by name case insensitive' do
    get "/api/v1/merchants/find_all?name=#{merchant1.name[0, 3]}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchants = response_body[:data]

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant[:attributes][:name]).to include(merchant1.name[0, 3])
      expect(merchant[:attributes]).to_not have_key(:created_at)
    end
  end
end
