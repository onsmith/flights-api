class DatabasesController < ApplicationController
  before_action :authenticate_user



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



  ## DELETE /airlines
  def destroy_airlines
    Airline.where(user: current_user).delete_all
  end



  ## DELETE /airports
  def destroy_airports
    Airport.where(user: current_user).delete_all
  end



  ## DELETE /flights
  def destroy_flights
    Flight.where(user: current_user).delete_all
  end



  ## DELETE /instances
  def destroy_instances
    Instance.where(user: current_user).delete_all
  end



  ## DELETE /itineraries
  def destroy_itineraries
    Itinerary.where(user: current_user).delete_all
  end



  ## DELETE /planes
  def destroy_planes
    Plane.where(user: current_user).delete_all
  end



  ## DELETE /seats
  def destroy_seats
    Seat.where(user: current_user).delete_all
  end



  ## DELETE /tickets
  def destroy_tickets
    Ticket.where(user: current_user).delete_all
  end
end