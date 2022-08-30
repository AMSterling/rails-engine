class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  # has_many :items, links: {
  #   self: :url,
  #   related: -> (object) {
  #     "https://merchants.com/#{object.id}/items"
  #   }
  # }
end
