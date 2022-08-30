class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  # has_many :items

  # attribute :active do
  #   true
  # end
end
