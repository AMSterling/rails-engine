class Api::V1::Revenue::RevenueController < ApplicationController
  include QuantityValidator
  before_action :param_validation, only: %i[index]
  before_action :quantity_validation, only: %i[unshipped]

  def index
    if between_dates?(params)
      revenue = Invoice.total_revenue(params[:start], params[:end])
      render json: RevenueSerializer.new(revenue)
    end
  end

  def unshipped
    orders = Invoice.unshipped_order(params[:quantity])
    render json: UnshippedOrderSerializer.new(orders)
  end

  def weekly
    reports = Invoice.weekly_revenue
    render json: WeeklyRevenueSerializer.new(reports)
  end

  private

  def param_validation
    unless params[:start].present? && params[:end].present? &&
      params[:start] < params[:end] &&
      between_dates?(params).match?(/\d{4}\-\d{2}\-\d{2}/)
      render json: { data: {}, error: 'error' }, status: :bad_request
    end
  end

  def between_dates?(params)
    params[:start] && params[:end]
  end
end
