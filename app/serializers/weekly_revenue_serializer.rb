class WeeklyRevenueSerializer
  include JSONAPI::Serializer
  attributes :week, :revenue

  attribute :week do |object|
    object.week.strftime('%F')
  end
end
