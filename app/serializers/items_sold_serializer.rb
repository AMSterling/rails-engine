class ItemsSoldSerializer
  include JSONAPI::Serializer
  attributes :name, :count
end
