class Api::V1::Revenue::MerchantsController < ApplicationController
  include QuantityValidator
  before_action :quantity_validation, only: %i[index]

  def index
    merchants = Merchant.highest_revenue(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(merchant)
  end
end
