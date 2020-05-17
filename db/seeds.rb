# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.create(
  email: "test123@gmail.com",
  password: "111111",
  name: "GoodbytesTester"
)
org = Organization.create(
  name: "lalalamove"
)
org_role = org.organizations_users.create(
  user_id: u.id,
  role: admin
)
channel_list = [
  "lalalaChannel",
  "ChannelAwesome",
  "CoolTV"
]
channel_list.each do |name|
  channel = org.channels.create(
    name: name
  )
  channel.channels_org_users.create(
    organizations_user_id: org_role.id,
    role: admin
  )
end