
# Seed of cities and airports

if City.count != 4925
  # destroy all existing Airport datasets
  puts "detroy all airports..."
  Airport.destroy_all
  Attachment.destroy_all
  City.destroy_all
  puts "airports destroyed"

  # parsing all airports and cities
  puts "get data from json..."
  airport_url = 'https://raw.githubusercontent.com/ram-nadella/airport-codes/master/airports.json'
  airports_serialized = open(airport_url).read
  airports = JSON.parse(airports_serialized)

  puts "creating the airports and cities..."

  airports.each do |airport|
    airport_code = airport.last["iata"]
    airport_name = airport.last["name"]
    city_name = airport.last["city"]
    city_country = airport.last["country"]
    city_timezone = airport.last["timezone"]

    # get city or create a new one
    if City.where("name = ? and country = ?", city_name, city_country) == [] && city_country != 'Canada'
      new_city = City.new(name: city_name, country: city_country, timezone: city_timezone)
      new_city.save
      new_airport = Airport.new(name: airport_name, acronym: airport_code)
      new_airport.city = new_city
      new_airport.save
    else
      city = City.where("name = ?", city_name)
      new_airport = Airport.new(name: airport_name, acronym: airport_code, city_id: city.ids.first)
      # new_airport.city = city
      new_airport.save
    end
  end

  puts "Created #{Airport.count} airports and #{City.count} cities."
else
  puts "Airports and Cities are already created, Sir."
end

# Seed of the airlines

if Airline.count != 806
  # destroy all existing Airport datasets
  puts "detroy all airlines and flights..."
  FlightBundleFlight.destroy_all
  FlightBundle.destroy_all
  Flight.destroy_all
  Airline.destroy_all
  puts "airlines and flights has been destroyed"

  # parsing all airlines
  puts "getting json for the airlines..."
  airline_url = 'https://raw.githubusercontent.com/BesrourMS/Airlines/master/airlines.json'
  airlines_serialized = open(airline_url).read
  airlines = JSON.parse(airlines_serialized)

  puts "creating airlines now..."
  airlines.each do |airline|

    airline_acronym = airline["iata"]
    airline_name = airline["name"]

    new_airline = Airline.new(acronym: airline_acronym, name: airline_name).save # if Airline.where("acronym = ?", airline_acronym) == []

  end
  puts "Created #{Airline.count} airlines."
else
  puts "Airlines are already created, Sir."
end

# deleting all the airports where city is nil
puts "deleting airports without a city"
Airport.where(city_id: nil).destroy_all
puts "airports without a city has been deleted"


# seeding flights
if Flight.count != 20000

  puts "deleting all the flights..."
  number_of_flights = Flight.count
  FlightBundleFlight.destroy_all
  FlightBundle.destroy_all
  # Flight.destroy_all
  puts "#{number_of_flights} has been deleted."

  puts "creating 20000 f**king flights..."
  # average speed of a plane 885 km/hr
  airplane_speed = 885.0

  20000.times do
    # get random start and end airport

    # Munich, Berlin, Paris, Lisbon, London, Madrid, Bratislava, Oslo, Reykjavik, Rome, Vienna, Warschau, Stockholm, Budapest, Dublin
    start_airport = ['MUC','TXL','SXF', 'CDG', 'LGW', 'LHR', 'LIS', 'MAD', 'BTS', 'OSL', 'RKV', 'FCO', 'VIE', 'WAW', 'ARN', 'BUD', 'DUB'].sample

    # search for start airport city
    start_airport = Airport.where(acronym: start_airport)
    city_one = start_airport[0].city.name


    exclude_airports = Airport.where(city_id: start_airport[0].city_id).pluck(:acronym)

    end_airport = ['MUC','TXL','SXF', 'CDG', 'LGW', 'LHR', 'LIS', 'MAD', 'BTS', 'OSL', 'RKV', 'FCO', 'VIE', 'WAW', 'ARN', 'BUD', 'DUB']
    end_airport = end_airport - exclude_airports
    end_airport = end_airport.sample

    # search for end_airport city
    end_airport = Airport.where(acronym: end_airport)
    city_two = end_airport[0].city.name

    # get random airline
    # airline = Airline.limit(1).order("RANDOM()")
    random_airline = ['Ryanair', 'Lufthansa', 'KLM', 'EasyJet', 'Turkish Airlines', 'TAP Portugal', 'Air France', 'Aeroflot', 'Pegasus Airlines', 'Wizz Air', 'Eurowings', 'Virgin Atlantic', 'Norwegian Air'].sample
    airline = Airline.where(name: random_airline).first

    # calculate random start date
    departure_hour = rand(6..22)
    departure_min = [5, 10, 15 ,20 ,25 ,30 ,35 ,40 ,45 ,50 ,55].sample.to_f
    departure_hour_min = "#{departure_hour + (departure_min / 60.0)}".to_f
    day_range = rand(1..30)
    departure_datetime = Date.today.to_datetime + day_range + (departure_hour_min / 24.0)

    # distance_km = distance["distance"]
    distance_km = [2316.0, 2000.0, 1600.0, 1400.0, 900.0].sample
    flight_duration = distance_km / airplane_speed
    # time_offset_hours = distance["travel"]["timeOffset"]["offsetMins"] / 60

    arrival_datetime = departure_datetime + (flight_duration / 24.0) #+ time_offset_hours

    price = rand(15..449)

    new_flight = Flight.new(
      departure_datetime: departure_datetime,
      arrival_datetime: arrival_datetime,
      price: price,
      flight_duration: flight_duration,
      from_airport_id: start_airport.ids.first,
      to_airport_id: end_airport.ids.first,
      airline_id: airline.id
      )
    new_flight.save
    puts "1000 flights" if Flight.count == 1000
    puts "2000 flights" if Flight.count == 2000
    puts "3000 flights" if Flight.count == 3000
    puts "4000 flights" if Flight.count == 4000
    puts "5000 flights" if Flight.count == 5000
    puts "6000 flights" if Flight.count == 6000
    puts "7000 flights" if Flight.count == 7000
    puts "8000 flights" if Flight.count == 8000
    puts "9000 flights" if Flight.count == 9000
    puts "10000 flights" if Flight.count == 10000
    puts "11000 flights" if Flight.count == 11000
    puts "12000 flights" if Flight.count == 12000
    puts "13000 flights" if Flight.count == 13000
    puts "14000 flights" if Flight.count == 14000
    puts "15000 flights" if Flight.count == 15000
    puts "16000 flights" if Flight.count == 16000
    puts "17000 flights" if Flight.count == 17000
    puts "18000 flights" if Flight.count == 18000
    puts "19000 flights.. pray for it" if Flight.count == 19000
  end
else
  puts "There are already 1000 flights, Sir."
end

puts "all flights created"
puts "fetching the city description, acitivities and picture"

# city description
all_cities = ['Munich', 'Berlin', 'Paris', 'Lisbon', 'London', 'Madrid', 'Bratislava', 'Oslo', 'Reykjavik', 'Rome', 'Vienna', 'Warsaw', 'Stockholm', 'Budapest', 'Dublin']

img_munich = 'https://cdn.pixabay.com/photo/2017/10/18/10/20/munich-2863539_1280.jpg'
img_berlin = 'https://images.unsplash.com/photo-1515711883701-0f1104702fff?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=9eca1da4d1f9e9136e06ec5be3ba923b&auto=format&fit=crop&w=934&q=80'
img_paris = 'https://cdn.pixabay.com/photo/2018/04/06/17/17/paris-3296269_1280.jpg'
img_lisbon = 'https://images.unsplash.com/photo-1531258932533-1ecc042f713a?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=5c060456302b94ec3f00ed512968bd1f&auto=format&fit=crop&w=1950&q=80'
img_London = 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=18dcdd4e1c2627bc3c9bf68645c9ae92&auto=format&fit=crop&w=1950&q=80'
img_madrid = 'https://images.unsplash.com/photo-1512847819326-205ee05f3ceb?ixlib=rb-0.3.5&s=c6bda1339ae942a71268fae3cec7c97a&auto=format&fit=crop&w=1950&q=80'
img_bratislava = 'https://cdn.pixabay.com/photo/2016/08/04/15/57/bratislava-1569359_1280.jpg'
img_oslo = 'https://images.unsplash.com/photo-1504971588239-ba9c6ac9097f?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=7e88faff53045331e1bad18806ab3b8e&auto=format&fit=crop&w=2850&q=80'
img_rey = 'https://images.unsplash.com/photo-1476036840956-982d94275a3a?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e457dd8aaae18f9fae01276952d08a5b&auto=format&fit=crop&w=1950&q=80'
img_rome = 'https://cdn.pixabay.com/photo/2014/03/26/05/47/vittorio-emanuele-monument-298412_1280.jpg'
img_vienna = 'https://images.unsplash.com/photo-1519923041107-e4dc8d9193da?ixlib=rb-0.3.5&s=5f1f40dad83fbdda6773c3c3728e0721&auto=format&fit=crop&w=1950&q=80'
img_warsaw = 'https://cdn.pixabay.com/photo/2016/05/29/21/09/warsaw-1423864_1280.jpg'
img_stockholm = 'https://images.unsplash.com/photo-1497217968520-7d8d60b7bc25?ixlib=rb-0.3.5&s=6714b91de94028c081135d2a3fd5954e&auto=format&fit=crop&w=1950&q=80'
img_budapest = 'https://cdn.pixabay.com/photo/2018/02/23/22/00/water-3176750_1280.jpg'
img_dublin = 'https://cdn.pixabay.com/photo/2018/04/12/15/48/dublin-3313820_1280.jpg'

img_array = [img_munich, img_berlin, img_paris, img_lisbon, img_London, img_madrid, img_bratislava, img_oslo, img_rey, img_rome, img_vienna, img_warsaw, img_stockholm, img_budapest, img_dublin]
i = 0

all_cities.each do |city|
  puts "for #{city}"
  # get data from distance24 API
  distance_url = "https://www.distance24.org/route.json?stops=#{city}|Tokyo"
  distance_serialized = open(distance_url).read
  distance = JSON.parse(distance_serialized)
  description = distance["stops"][0]["wikipedia"]["abstract"]

  # update the description of the city
  city_to_update = City.where(name: city).first
  city_to_update.description = description

  # insert acitivities when we find something

  #insert city picture url
  imaaage = img_array[i]
  att = Attachment.new(photo: open(imaaage))
  att.city_id = city_to_update.id
  att.save
  i += 1


  # save city
  city_to_update.save
end

# +++++++ Adding Airline urls for the Airlines we are Using +++++++++ #
used_airlines = ['Ryanair', 'Lufthansa', 'KLM', 'EasyJet', 'Turkish Airlines', 'TAP Portugal', 'Air France', 'Aeroflot', 'Pegasus Airlines', 'Wizz Air', 'Eurowings', 'Virgin Atlantic', 'Norwegian Air']
used_airlines_urls = ['https://www.ryanair.com','https://www.lufthansa.com/online/portal/lh_com/de/homepage','https://www.klm.com/','https://www.easyjet.com/','https://www.turkishairlines.com/','https://www.flytap.com/','https://www.airfrance.com/','https://www.aeroflot.ru/xx-en?_preferredLocale=xx&_preferredLanguage=en','https://www.flypgs.com/','https://wizzair.com/','https://www.eurowings.com/','https://www.virginatlantic.com/','https://www.norwegian.com/']
counter = 0
used_airlines.each do |airline|
  airline_update = Airline.where(name: airline).first
  airline_update.url = used_airlines_urls[counter]
  airline_update.save
  counter += 1
end


# ++++ END OF SEED ++++ #
puts "You have just been seeded Duuuude."
