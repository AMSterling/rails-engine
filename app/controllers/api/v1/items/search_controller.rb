class Api::V1::Items::SearchController < ApplicationController
  before_action :param_validation

  def index
    items = Item.find_item(params[:name]).order(:name)
    if !items.empty?
      render json: ItemSerializer.new(items)
    else
      render json: { data: [] }, status: 400
    end
  end

  private
  def param_validation
    if !params[:name].present?
      render json: { data: {} }, status: 400
    end
  end
end
