class Api::V1::Revenue::MerchantsController < ApplicationController

  def index
    if !params[:quantity].present?
      render json: {data: [], error: 'error'}, status: 400
    elsif (params[:quantity].to_i < 0) || (params[:quantity].scan(/\d/).empty?)
      render json: { data: {} }, status: :bad_request
    else
      merchants = Merchant.highest_revenue(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants)
    end
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(merchant)
  end
end
