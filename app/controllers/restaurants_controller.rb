class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :index, :show]
  before_action :set_restaurant, only: [:show]

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
    @restaurants = @restaurants.tagged_with(params[:tag_list]) if params[:tag_list]&.any?
    @booking = Booking.new
    @group_size = params[:group_size]
  end

  def show
    @booking = Booking.new
    @tags = Restaurant::MOODS
    authorize @restaurant
    @markers = [{
      lat: @restaurant.latitude,
      lng: @restaurant.longitude,
      info_window: render_to_string(partial: "info_window", locals: {restaurant: @restaurant})
    }]
  end

  private

  def restaurant
    params.require(:restaurant).permit(:name, :description, :tags_list)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_moods
    @moods = Restaurant::MOODS
  end
end
