# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

krakow = Station.create(name: "Kraków Główny")
warszawa = Station.create(name: "Warszawa Centralna")
krakow_warszawa = Connection.create(station: krakow, connected_station: warszawa)

kurs_1 = Course.create(departure_time: Time.zone.now, arrival_time: Time.zone.now+1.day, connection: krakow_warszawa, price: 199.99)
kurs_2 = Course.create(departure_time: Time.zone.now+1.day, arrival_time: Time.zone.now+2.day, connection: krakow_warszawa, price: 12.99)
