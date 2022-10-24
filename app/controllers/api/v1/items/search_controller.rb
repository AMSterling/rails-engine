class Api::V1::Items::SearchController < ApplicationController
  before_action :param_check

  def index
    if price_between?(params)
      @item = Item.filtered(params.slice(:min_price, :max_price))
      # @item = items.filter_by_min_price(params[:min_price]).filter_by_max_price(params[:max_price])
      if @item.present?
        render json: ItemSerializer.new(@item)
      else
        render json: { data: [], error: 'error' }, status: :bad_request
      end
    else
      items = Item.where(nil)
      scope_params(params).each do |key, value|
        @item = items.public_send("filter_by_#{key}", value) if !value.empty? && !value.to_f.negative?
      end
      if @item.present?
        render json: ItemSerializer.new(@item)
      else
        render json: { data: [], error: 'error' }, status: :bad_request
      end
    end
  end

  def show
    if price_between?(params)
      @item = Item.filtered(params.slice(:min_price, :max_price))
      if @item.present?
        render json: ItemSerializer.new(@item.first)
      else
        render json: { data: {}, error: 'error' }, status: :bad_request
      end
    else
      items = Item.where(nil)
      scope_params(params).each do |key, value|
        @item = items.public_send("filter_by_#{key}", value) if !value.empty? && !value.to_f.negative?
      end
      if @item.present?
        render json: ItemSerializer.new(@item.first)
      else
        render json: { data: {}, error: 'error' }, status: :bad_request
      end
    end
  end

  private

  def scope_params(params)
    params.slice(:name, :min_price, :max_price)
  end

  def price_between?(params)
    params[:min_price] && params[:max_price]
  end

  def param_check
    render status: :bad_request if params[:name] && (params[:min_price] || params[:max_price])
  end
end
