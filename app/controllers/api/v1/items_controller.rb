class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[update destroy]

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: {
        error: 'Item does not exist or is no longer available'
      }, status: :not_found
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render status: :not_found
    end
  end

  def update
    if @item.update(item_params)
      render json: ItemSerializer.new(@item)
    else
      render status: :not_found
    end
  end

  def destroy
    @item.invoices.delete_empty_invoice if @item.invoices.exists?
    @item.destroy
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(
                                  :name,
                                  :description,
                                  :unit_price,
                                  :merchant_id
                                )
  end
end
