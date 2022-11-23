class BookingsController < ApplicationController
  def index
    @bookings = policy_scope(Booking)
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @booking = Booking.new
    @booking.restaurant = @restaurant
    @booking.user = current_user
    authorize @booking
    if @booking.save
      redirect_to bookings_path
    else
      render "restaurants/show", status: :unprocessable_entity
    end
  end

  def update
    @booking = Booking.find(params[:id])
    @restaurant = @booking.restaurant
    # raise
    @user = current_user
    authorize @booking
    if @booking.update(booking_params)
      bookings = current_user.bookings.where(status: %w[pending restaurant_accepted])
      bookings.update_all(status: "user_rejected")
      redirect_to bookings_path
    else
      render :index
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:status)
  end
end
