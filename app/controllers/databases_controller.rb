class DatabasesController < ApplicationController
  before_action :authenticate_user, only: [:destroy]



  ## DELETE /databases
  def destroy
    Ticket.where(user: current_user).delete_all
    Itinerary.where(user: current_user).delete_all
    Seat.where(user: current_user).delete_all
    Instance.where(user: current_user).delete_all
    Flight.where(user: current_user).delete_all
    Airport.where(user: current_user).delete_all
    Plane.where(user: current_user).delete_all
    Airline.where(user: current_user).delete_all
  end
end