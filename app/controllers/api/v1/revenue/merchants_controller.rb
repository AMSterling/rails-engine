class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if !params[:quantity].present?
      render json: {data: [], error: 'error'}, status: 400
    elsif (params[:quantity].to_i < 0) || (params[:quantity].scan(/\d/).empty?)
      render json: { data: {} }, status: :bad_request
    else
      merchants = Merchant.top_revenue(params[:quantity])
      render json: RevenueSerializer.new(merchants)
    end
  end

  def show
    if Merchant.exists?(params[:id])
      merchant = Merchant.merchant_revenue(params[:id])
      render json: RevenueSerializer.new(merchant)
    else
      render json: { status: 'Not Found' }, status: :not_found
    end
  end
end
