module QuantityValidator
  extend ActiveSupport::Concern

  def quantity_validation
    if !params[:quantity].present?
      render json: {data: [], error: 'error'}, status: 400
    elsif (params[:quantity].to_i < 0) || (params[:quantity].scan(/\d/).empty?)
      render json: { data: {} }, status: :bad_request
    else
      params[:quantity]
    end
  end
end
