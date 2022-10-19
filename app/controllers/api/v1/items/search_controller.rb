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
    items = Item.where(nil)
    if search_nil?(params) || name_and_price?(params)
      render status: 400
    elsif price_between?(params)
      @item = items.find_min_price(params[:min_price]).find_max_price(params[:max_price])
      if @item.present?
        render json: ItemSerializer.new(@item.first)
      else
        render json: { data: {}, error: 'error' }, status: 400
      end
    else
      scope_params.each do |key, value|
        if !value.empty? && !value.to_f.negative?
          @item = items.public_send("find_#{key}", value)
        end
      end
      if @item.present?
        render json: ItemSerializer.new(@item.first)
      else
        render json: { data: {}, error: 'error' }, status: 400
      end
    end
  end

  private
  def scope_params
    params.permit(:name, :min_price, :max_price)
  end

  def search_nil?(params)
    params[:name].nil? && params[:min_price].nil? && params[:max_price].nil?
  end

  def price_between?(params)
    params[:min_price] && params[:max_price]
  end

  def name_and_price?(params)
    (params[:name] && params[:min_price]) || (params[:name] && params[:max_price])
  end
end
