class RevenueSerializer
  include JSONAPI::Serializer

  def self.new(data)
    {
      data: data
    }
  end
end
