# module Response
#   def item_json_response(object, status = :ok)
#     render json: ItemSerializer.new(object), status: status
#   end
#
#   def merchant_json_response(object, status = :ok)
#     render json: MerchantSerializer.new(object), status: status
#   end
#
#   def error_response(message, status)
#     render json: message, status: status
#   end
# end
