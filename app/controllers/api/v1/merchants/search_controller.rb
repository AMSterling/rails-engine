class Api::V1::Merchants::SearchController < ApplicationController
  before_action :param_validation, :set_merchant, only: %i[index show]

  def index
    if @merchants.empty?
      render json: { data: [] }, status: :not_found
    else
      render json: MerchantSerializer.new(@merchants)
    end
  end

  def show
    if @merchants.empty?
      render json: { data: { message: 'Merchant not found' } }
    else
      render json: MerchantSerializer.new(@merchants.first)
    end
  end

  private
  
  def param_validation
    render json: { data: {} }, status: :bad_request if params[:name].blank?
  end

  def set_merchant
    @merchants = Merchant.find_merchant(params[:name]).order(:name)
  end
end
