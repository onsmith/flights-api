# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)




##
# Create Users
#
aaron = User.create! username: "onsmith", password: "qwerqwer"
kmp   = User.create! username: "kmp",     password: "qwerqwer"




##
# Create Airports
#

Airport.create!(
  name:     "Raleigh-Durham International Airport",
  code:     "RDU",
  latitude:  "",
  longitude: "",
  city:      "Raleigh",
  state:     "NC",
  city_url:  ""
)

Airport.create!(
  name:     "Logan International Airport",
  code:     "BOS",
  latitude:  "",
  longitude: "",
  city:      "Boston",
  state:     "MA",
  city_url:  ""
)

Airport.create!(
  name:     "Aaron Interfjord Airport",
  code:     "AAR",
  latitude:  "",
  longitude: "",
  city:      "Arendelle",
  state:     "FJ",
  city_url:  "",
  user:      aaron
)