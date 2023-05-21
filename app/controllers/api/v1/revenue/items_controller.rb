class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    if !params[:quantity].present?
      render json: {data: [], error: 'error'}, status: 400
    elsif (params[:quantity].to_i < 0) || (params[:quantity].scan(/\d/).empty?)
      render json: { data: {} }, status: :bad_request
    else
      items = Item.highest_revenue(params[:quantity])
      render json: ItemRevenueSerializer.new(items)
    end
  end
end
