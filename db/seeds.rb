require 'net/http'
require 'uri'
require 'json'

ADDRESSES = [
  "1-291-8 Sarugakucho, Chiyoda ku, Tokyo to", #works
  "2-9 Sarugakucho, Chiyoda ku, Tokyo to", #works
  "14-6 Daita, Setagaya ku, Tokyo to", #works
  "4-12-6 Omotesando, Shibuya ku, Tokyo to", #works
  "3-15-24 Jingumae, Shibuya ku, Tokyo to", #works
  "7-2 Shinsencho, Shibuya ku, Tokyo to", #works
  "1-20-1 Shibuya, Shibuya ku, Tokyo to", #works
  "9 Sakuragaokacho, Shibuya ku, Tokyo to", #works
  "7-20 Nishishinjuku, Shinjuku ku, Tokyo to", #works
  "7-17 Nishishinjuku, Shinjuku ku, Tokyo to", #works
  "1-6 Hyakunincho, Shinjuku ku, Tokyo to", #works
  "1-3-7 Kabukicho, Shinjuku ku, Tokyo to", #works
  "3-35-16 Shinjuku, Shinjuku ku, Tokyo to", #works
  "1-54 Yoyogi, Shibuya ku, Tokyo to", #works
  "1-21 Shibuya, Shibuya ku, Tokyo to", #works
  "5-34 Jingumae, Shibuya ku, Tokyo to", #works
  "5-15 Roppongi, Minato ku, Tokyo to", #works
  "3-9-5 Roppongi, Minato ku, Tokyo to", #works
  "6-5 Roppongi, Minato ku, Tokyo to", #works
  "7-17 Roppongi, Minato ku, Tokyo to", #works
  "5-15-5 Roppongi, Minato ku, Tokyo to", #works
  "4-2 Shibakoen, Minato ku, Tokyo to", #works
  "9-8 Sakuragaokacho, Shibuya ku, Tokyo to", #works
  "2-13 Shibuya, Shibuya ku, Tokyo to", #works
  "4-2-12 Shibuya, Shibuya ku, Tokyo to", #works
  "32-12 Udagawacho, Shibuya ku, Tokyo to", #works
  # "2 Kamimeguro, Meguro ku, Tokyo to",
  # "4-3 Nakameguro, Meguro ku, Tokyo to",
  # "4-1 Nakameguro, Meguro ku, Tokyo to",
  "5-5 Ginza, Chuo ku, Tokyo to", #works
  "5-8 Ginza, Chuo ku, Tokyo to", #works
  "2-6 Ginza, Chuo ku, Tokyo to", #works
  "6-14 Ginza, Chuo ku, Tokyo to", #works
  "8-7 Ginza, Chuo ku, Tokyo to", #works
  "6-13 Ueno, Taito ku, Tokyo to", #works
  "4-9-2 Ueno, Taito ku, Tokyo to", #works
  "2-8-2 Ueno, Taito ku, Tokyo to", #works
  "3-19-4 Ueno, Taito ku, Tokyo to", #works
  "1-12 Higashiueno, Taito ku, Tokyo to", #works
  "1-29-4 Senju, Adachi ku, Tokyo to", #works
  "2-7 Senju, Adachi ku, Tokyo to", #works
  "3-58 Senju, Adachi ku, Tokyo to", #works
  "2-24 Kitazawa, Setagaya ku, Tokyo to", #works
  "2-29 Kitazawa, Setagaya ku, Tokyo to", #works
  "3-20 Kitazawa, Setagaya ku, Tokyo to", #works
  "2-17-3 Kitazawa, Setagaya ku, Tokyo to", #works
  "5-35 Daita, Setagaya ku, Tokyo to", #works
  "1-28 Yoyogi, Shibuya ku, Tokyo to", #works
  "5-13 Sendagaya, Shibuya ku, Tokyo to", #works
  "1-8 Jingumae, Shibuya Ku, Tokyo to", #works
  "6-12 Jingumae, Shibuya Ku, Tokyo to", #works
  "1-3 Shoto, Shibuya ku, Tokyo to", #works
  "10-15 Maruyamacho, Shibuya ku, Tokyo to", #works
]
def separator_line
  puts "-------------------"
  puts "-------------------"
end

def create_users
  puts "Generating humans 🤪"
  5.times do
    User.create!(
      email: Faker::Internet.unique.email,
      password: Faker::Internet.password(min_length: 8),
      name: Faker::Internet.unique.username
    )
  end
  separator_line
end

def create_restaurants
  puts "Building restaurants 🚧"
  categories = ["All you can eat", "All you can drink", "Japanese, Kaiseki, Washoku", "Sushi", "Soba", "Tempura", "Yakiniku", "Steak, Teppanyaki", "Yakitori", "French", "Italian, Trattoria", "Western Cousine", "Chinese", "Bar", "Pub", "Izakaya"]
  seed_addresses = ADDRESSES.shuffle
  index = 0
  40.times do
    restaurant = Restaurant.create!(
      user: User.all.sample,
      name: Faker::Restaurant.name,
      description: Faker::Restaurant.description,
      category: categories.sample,
      address: seed_addresses[index],
      maximum_number: rand(1..30),
      price_range: "¥ #{[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000].sample}"
    )
    index += 1
    puts "Finding two #{restaurant.category} images for #{restaurant.name}"
    add_restaurant_moods(restaurant)
    2.times do
      file = URI.open("http://source.unsplash.com/featured/?#{restaurant.category}")
      restaurant.photos.attach(io: file, filename: "nes.png", content_type: "image/png")
    end
    restaurant.save
  end
  separator_line
end

def add_restaurant_moods(restaurant)
  my_restaurant = restaurant
  puts "Adding some tags #️⃣"
  mood = ["Hip", "Casual", "Relaxing", "Party", "Chill", "Energetic", "Modern", "Fancy"]
  my_restaurant.tag_list.add(mood.sample)
  puts "#{my_restaurant.name} is now: #{my_restaurant.tag_list} 🤙🏻"
  my_restaurant.save
end

def create_bookings
  20.times do
    puts "Creating random bookings"
    Booking.create!(
      status: 0,
      user: User.all.sample,
      restaurant:  Restaurant.all.sample,
      number_of_people: rand(1..30)
    )
  end
  separator_line
end

def create_erika_booking
  puts "Creating booking for #{User.last.name} "
  Booking.create!(
    user: User.last,
    restaurant:  Restaurant.last,
    number_of_people: 10
  )
  separator_line
end

def hotpepper_restaurants
  puts "Getting Hotpepper restaurants 🌶️"

  def izakayas
    categories = ["izakaya", "italian", "french", "bar", "chinese", "asia", "karaoke"]
    key = "eb23cb3ca1015ddc"
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{key}&name=#{categories[0]}&large_area=Z011&format=json"
    api = URI.parse(url)
    json = Net::HTTP.get(api)
    parse_result = JSON.parse(json)
    @result = parse_result["results"]["shop"]

    puts "Creating Izakayas.."
    @result.each do |restaurant|
      new_restaurant = Restaurant.create!(
        user: User.all.sample,
        name: restaurant["name"],
        description: Faker::Restaurant.description,
        category: restaurant["genre"]["name"],
        address: restaurant["address"],
        longitude: restaurant["lng"],
        latitude: restaurant["lat"],
        maximum_number: restaurant["capacity"],
        price_range: "¥ #{[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000].sample}"
      )
      file = URI.open("#{restaurant["photo"]["pc"]["l"]}")
      new_restaurant.photos.attach(io: file, filename: "nes.png", content_type: "image/png")
      add_restaurant_moods(new_restaurant)
      new_restaurant.save
    end

  end

  def italian
    categories = ["izakaya", "italian", "french", "bar", "chinese", "asia", "karaoke"]
    key = "eb23cb3ca1015ddc"
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{key}&name=#{categories[1]}&large_area=Z011&format=json"
    api = URI.parse(url)
    json = Net::HTTP.get(api)
    parse_result = JSON.parse(json)
    @result = parse_result["results"]["shop"]

    puts "Creating Italian restaurants"
    @result.each do |restaurant|
      new_restaurant = Restaurant.create!(
        user: User.all.sample,
        name: restaurant["name"],
        description: Faker::Restaurant.description,
        category: restaurant["genre"]["name"],
        address: restaurant["address"],
        longitude: restaurant["lng"],
        latitude: restaurant["lat"],
        maximum_number: restaurant["capacity"],
        price_range: "¥ #{[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000].sample}"
      )
      file = URI.open("#{restaurant["photo"]["pc"]["l"]}")
      new_restaurant.photos.attach(io: file, filename: "nes.png", content_type: "image/png")
      add_restaurant_moods(new_restaurant)
      new_restaurant.save
    end

  end

  def french
    categories = ["izakaya", "italian", "french", "bar", "chinese", "asia", "karaoke"]
    key = "eb23cb3ca1015ddc"
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{key}&name=#{categories[2]}&large_area=Z011&format=json"
    api = URI.parse(url)
    json = Net::HTTP.get(api)
    parse_result = JSON.parse(json)
    @result = parse_result["results"]["shop"]

    puts "Creating French Restaurants.."
    @result.each do |restaurant|
      new_restaurant = Restaurant.create!(
        user: User.all.sample,
        name: restaurant["name"],
        description: Faker::Restaurant.description,
        category: restaurant["genre"]["name"],
        address: restaurant["address"],
        longitude: restaurant["lng"],
        latitude: restaurant["lat"],
        maximum_number: restaurant["capacity"],
        price_range: "¥ #{[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000].sample}"
      )
      file = URI.open("#{restaurant["photo"]["pc"]["l"]}")
      new_restaurant.photos.attach(io: file, filename: "nes.png", content_type: "image/png")
      add_restaurant_moods(new_restaurant)
      new_restaurant.save
    end
  end

  def bar
    categories = ["izakaya", "italian", "french", "bar", "chinese", "asia", "karaoke"]
    key = "eb23cb3ca1015ddc"
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{key}&name=#{categories[3]}&large_area=Z011&format=json"
    api = URI.parse(url)
    json = Net::HTTP.get(api)
    parse_result = JSON.parse(json)
    @result = parse_result["results"]["shop"]

    puts "Creating bars.."
    @result.each do |restaurant|
      new_restaurant = Restaurant.create!(
        user: User.all.sample,
        name: restaurant["name"],
        description: Faker::Restaurant.description,
        category: restaurant["genre"]["name"],
        address: restaurant["address"],
        longitude: restaurant["lng"],
        latitude: restaurant["lat"],
        maximum_number: restaurant["capacity"],
        price_range: "¥ #{[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000].sample}"
      )
      file = URI.open("#{restaurant["photo"]["pc"]["l"]}")
      new_restaurant.photos.attach(io: file, filename: "nes.png", content_type: "image/png")
      add_restaurant_moods(new_restaurant)
      new_restaurant.save
    end

  end

  def chinese
    categories = ["izakaya", "italian", "french", "bar", "chinese", "asia", "karaoke"]
    key = "eb23cb3ca1015ddc"
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{key}&name=#{categories[4]}&large_area=Z011&format=json"
    api = URI.parse(url)
    json = Net::HTTP.get(api)
    parse_result = JSON.parse(json)
    @result = parse_result["results"]["shop"]

    puts "Creating chinese restaurants.."
    @result.each do |restaurant|
      new_restaurant = Restaurant.create!(
        user: User.all.sample,
        name: restaurant["name"],
        description: Faker::Restaurant.description,
        category: restaurant["genre"]["name"],
        address: restaurant["address"],
        longitude: restaurant["lng"],
        latitude: restaurant["lat"],
        maximum_number: restaurant["capacity"],
        price_range: "¥ #{[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000].sample}"
      )
      file = URI.open("#{restaurant["photo"]["pc"]["l"]}")
      new_restaurant.photos.attach(io: file, filename: "nes.png", content_type: "image/png")
      add_restaurant_moods(new_restaurant)
      new_restaurant.save
    end

  end

  def asia
    categories = ["izakaya", "italian", "french", "bar", "chinese", "asia", "karaoke"]
    key = "eb23cb3ca1015ddc"
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{key}&name=#{categories[5]}&large_area=Z011&format=json"
    api = URI.parse(url)
    json = Net::HTTP.get(api)
    parse_result = JSON.parse(json)
    @result = parse_result["results"]["shop"]

    puts "Creating asian restaurants.."
    @result.each do |restaurant|
      new_restaurant = Restaurant.create!(
        user: User.all.sample,
        name: restaurant["name"],
        description: Faker::Restaurant.description,
        category: restaurant["genre"]["name"],
        address: restaurant["address"],
        longitude: restaurant["lng"],
        latitude: restaurant["lat"],
        maximum_number: restaurant["capacity"],
        price_range: "¥ #{[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000].sample}"
      )
      file = URI.open("#{restaurant["photo"]["pc"]["l"]}")
      new_restaurant.photos.attach(io: file, filename: "nes.png", content_type: "image/png")
      add_restaurant_moods(new_restaurant)
      new_restaurant.save
    end

  end

  def karaoke
    categories = ["izakaya", "italian", "french", "bar", "chinese", "asia", "karaoke"]
    key = "eb23cb3ca1015ddc"
    url = "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{key}&name=#{categories[6]}&large_area=Z011&format=json"
    api = URI.parse(url)
    json = Net::HTTP.get(api)
    parse_result = JSON.parse(json)
    @result = parse_result["results"]["shop"]

    puts "Creating Karaoke bars.."
    @result.each do |restaurant|
      new_restaurant = Restaurant.create!(
        user: User.all.sample,
        name: restaurant["name"],
        description: Faker::Restaurant.description,
        category: restaurant["genre"]["name"],
        address: restaurant["address"],
        longitude: restaurant["lng"],
        latitude: restaurant["lat"],
        maximum_number: restaurant["capacity"],
        price_range: "¥ #{[1000,2000,3000,4000,5000,6000,7000,8000,9000,10000].sample}"
      )
      file = URI.open("#{restaurant["photo"]["pc"]["l"]}")
      new_restaurant.photos.attach(io: file, filename: "nes.png", content_type: "image/png")
      add_restaurant_moods(new_restaurant)
      new_restaurant.save
    end

  end

  izakayas
  italian
  french
  bar
  chinese
  asia
  karaoke
  puts "Finished creating API-restaurants"
end

def destroy_all_things
  puts "Destorying all bookings! 😈"
  Booking.destroy_all
  puts "Destroying all restaurants 🔥"
  Restaurant.destroy_all
  puts "Deleting all humans 👽"
  User.destroy_all
  separator_line
end

destroy_all_things
create_users
create_restaurants
hotpepper_restaurants


puts "Generating Ozei 💎"
puts "....Soren created! 🤠"
soren = User.create!(
  email: "soren@ozei.fun",
  password: "123123",
  name: "Soren"
)
puts "....Mattias created! 🤓"
mattias = User.create!(
  email: "mattias@ozei.fun",
  password: "123123",
  name: "Mattias"
)
puts "....Yumi created! 👩🏻"
yumi = User.create!(
  email: "Yumi@ozei.fun",
  password: "123123",
  name: "Yumi"
)
puts "....Erika created! 💃🏻"
erika = User.create!(
  email: "Erika@ozei.fun",
  password: "123123",
  name: "Erika"
)
soren.save
mattias.save
yumi.save
erika.save
separator_line

puts "Creating Yumi's fat curry 🍛"
yumi_restaurant = Restaurant.create!(
  user: yumi,
  name: "Yumi's fat curry",
  description: "Curry, curry, curry and more curry!!! 🍛",
  category: "All you can eat",
  address: "6-12 Jingumae, Shibuya Ku, Tokyo",
  maximum_number: 10,
  price_range: "¥1000"
)
index_img = 0
yumi_images = [
    "https://pbs.twimg.com/media/FLuh35iaMAIgaI4.jpg",
    "https://i8b2m3d9.stackpathcdn.com/wp-content/uploads/2021/12/Katsu_Curry_7011bsq.jpg",
    "https://rimage.gnst.jp/livejapan.com/public/article/detail/a/00/00/a0000480/img/basic/a0000480_main.jpg?20201023102522",
    "https://grapee.jp/en/wp-content/uploads/73879_03.jpg"
  ]
4.times do
  file = URI.open("#{yumi_images[index_img]}")
  yumi_restaurant.photos.attach(io: file, filename: "nes.png", content_type: "image/png")
  index_img += 1
  puts "added image #{yumi_images[index_img - 1]}"
end
add_restaurant_moods(yumi_restaurant)
yumi_restaurant.save

puts "Creating Demo Restaurant 🚧"
demo_restaurant = Restaurant.create!(
  user: soren,
  name: "Bettako",
  description: "Come drink, eat and have a real local experience in Meguro! Maybe even make some new friends?",
  category: "Izakaya",
  address: "1-5-21 Shimomeguro, Meguro City, Tokyo to",
  longitude: 139.712492,
  latitude: 35.635164,
  maximum_number: 80,
  price_range: "¥2000"
)
demo_index = 0
demo_images = [
  "https://tabelog.com/imgview/original?id=r44612125955057",
  "https://tabelog.com/imgview/original?id=r78907187882174",
  "https://tabelog.com/imgview/original?id=r79711187883032",
  "https://tabelog.com/imgview/original?id=r47981190098591"
]
4.times do
  demo_file = URI.open("#{demo_images[demo_index]}")
  demo_restaurant.photos.attach(io: demo_file, filename: "nes.png", content_type: "image/png")
  demo_index += 1
  puts "added image #{demo_images[demo_index - 1]}"
end
add_restaurant_moods(demo_restaurant)
demo_restaurant.save

separator_line
