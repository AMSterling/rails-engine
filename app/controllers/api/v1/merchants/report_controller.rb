class Api::V1::Merchants::ReportController < ApplicationController
  before_action :param_validation

  def index
    @merchants = Merchant.items_sold(params[:quantity])
    render json: MerchantReportSerializer.new(@merchants)
  end

  def param_validation
    if !params[:quantity].present?
      render json: {data: [], error: 'error'}, status: 400
    elsif (params[:quantity].to_i < 0) || (params[:quantity].scan(/\d/).empty?)
      render json: { data: {} }, status: :bad_request
    else
      params[:quantity]
    end
  end
end
