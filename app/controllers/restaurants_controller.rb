class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :index, :show]
  before_action :set_restaurant, only: [:show]

  require 'net/http'
  require 'uri'
  require 'json'

  # API START
  KEYID = "eb23cb3ca1015ddc"
  COUNT = 10
  LAT = "35.658"
  LNG = "139.7016"
  FORMAT = "json"
  PARAMS = {"key": KEYID, "count":COUNT, "lat":LAT, "lng":LNG,"format":FORMAT}

  def write_data_to_csv(params)
    api = URI.parse("http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=#{key}&lat=#{lat}&lng=#{lng}&range=#{range}&order=1&format=json")
    json = Net::HTTP.get(api)
    @result = JSON.parse(json)
  end



  def index
    @restaurants =
      if params[:query].present?
        policy_scope(Restaurant).search(params[:query])
      else
        policy_scope(Restaurant)
      end
    @markers = @restaurants.geocoded.map do |restaurant| {
      lat: restaurant.latitude,
      lng: restaurant.longitude,
      info_window: render_to_string(partial: "info_window", locals: {restaurant: restaurant})
    }
    end
    @tags = restaurant_moods
    @restaurants = @restaurants.where('maximum_number >= ?', params[:group_size]) if params[:group_size].present?
    @restaurants = @restaurants.tagged_with(params[:tags]) if params[:tags]&.any?
    @booking = Booking.new
  end

  def show
    authorize @restaurant
  end

  private

  def restaurant
    params.require(:restaurant).permit(:name, :tags_list)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_moods
    @moods = Restaurant::MOODS
  end
end
