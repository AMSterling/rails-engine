class Api::V1::Merchants::ReportController < ApplicationController
  include QuantityValidator
  before_action :quantity_validation

  def index
    merchants = Merchant.items_sold(params[:quantity])
    render json: ItemsSoldSerializer.new(merchants)
  end
end
