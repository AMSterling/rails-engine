# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails-engine_development db/data/rails-engine-development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

# 20.times do
#   Item.create!(
#     name: Faker::Commerce.product_name,
#     description: Faker::Lorem.paragraph,
#     unit_price: Faker::Number.decimal(l_digits: 2)
#   )
# end
#
# 5.times do
#   Merchant.create!(
#     name: Faker::Commerce.vendor
#   )
# end
#
# items = Item.all
#
# items.each do |item|
#   merchant_id_1 = rand(1..5)
#   merchant_id_2 = rand(1..5)
#
#     MerchantItem.create!([
#       {
#         item_id: item.id,
#         merchant_id: merchant_id_1
#       },
#       {
#         item_id: item.id,
#         merchant_id: merchant_id_2
#       }
#       ])
# end
