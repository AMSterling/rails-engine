class Api::V1::Revenue::ItemsController < ApplicationController
  include QuantityValidator
  before_action :quantity_validation

  def index
    items = Item.highest_revenue(params[:quantity])
    render json: ItemRevenueSerializer.new(items)
  end
end
