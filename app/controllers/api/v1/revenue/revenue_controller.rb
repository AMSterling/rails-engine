class Api::V1::Revenue::RevenueController < ApplicationController
  before_action :param_validation

  def index
    if between_dates?(params)
      revenue = Invoice.revenue(params[:start], params[:end])
      render json: RevenueSerializer.new(revenue)
    end
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
