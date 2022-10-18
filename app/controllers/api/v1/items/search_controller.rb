class Api::V1::Items::SearchController < ApplicationController

  def index
    items = Item.find_name(params[:name]).order(:name)
    if !params[:name].present?
      render json: { data: {} }, status: 400
    elsif !items.empty?
      render json: ItemSerializer.new(items)
    else
      render json: { data: [] }, status: 400
    end
  end

  def show
    @items = Item.all
    scope_params.each do |key, value|
      @item = @items.public_send("find_#{key}", value)
    end
    
    if @item.present?
      render json: ItemSerializer.new(@item.first)
    else
      render json: { data: {}, error: 'error' }, status: 400
    end
  end

  private
  def scope_params
    params.permit(:name, :min_price, :max_price)
  end
end
