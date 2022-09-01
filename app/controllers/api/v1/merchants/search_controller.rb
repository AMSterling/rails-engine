class Api::V1::Merchants::SearchController < ApplicationController
  before_action :param_validation

   def show
     merchants = Merchant.find_merchant(params[:name]).order(:name)
     if merchants.empty?
       render json: { data: {message: 'Merchant not found'} }
     else
       render json: MerchantSerializer.new(merchants.first)
     end
   end

  private
  def param_validation
    if !params[:name].present?
      render json: { data: {} }, status: 400
    end
  end
end
