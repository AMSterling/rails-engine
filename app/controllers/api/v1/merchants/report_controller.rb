class Api::V1::Merchants::ReportController < ApplicationController
  def index
    @merchants = Merchant.most_items_sold(params[:quantity])
    render json: MerchantReportSerializer.new(@merchants)
  end
end
