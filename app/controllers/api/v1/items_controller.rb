class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: {
        error: 'Item does not exist or is no longer available'
      }, status: 404
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      render status: 404
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render status: 404
    end
  end

  def destroy
    @item = Item.find(params[:id])

    if @item.invoices.empty?
      Item.destroy(params[:id])
    elsif @item.invoices.exists?
      @item.invoices.delete_empty_invoice
      @item.destroy
    else
      render status: 404
    end
  end

  private
  def item_params
    params.require(:item).permit(
                            :name,
                            :description,
                            :unit_price,
                            :merchant_id)
  end
end
