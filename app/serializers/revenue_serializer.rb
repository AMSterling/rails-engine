class RevenueSerializer
  include JSONAPI::Serializer

  def self.new(revenue)
    {
      data: {
        id: nil,
        type: 'revenue',
        attributes: {
          revenue: revenue
        }
      }
    }
  end
end
