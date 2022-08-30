require 'rails_helper'

describe 'Items API' do
  it 'can return a list of the merchants items' do
    id = create(:merchant).id
    create_list(:item, 5)

    get "/api/v1/merchants/#{id}/items"

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
