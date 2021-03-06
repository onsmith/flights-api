class SeedsController < ApplicationController
  before_action :authenticate_user



  ## POST /seed
  def create
    erase_prior_data
    load_data_from_seed_file
    insert_airlines
    insert_airports
    insert_planes
    insert_flights
    insert_instances
    insert_seats
    head :created
  end



  private
  def erase_prior_data
    Seat.where(user: current_user).delete_all
    Instance.where(user: current_user).delete_all
    Flight.where(user: current_user).delete_all
    Plane.where(user: current_user).delete_all
    Airport.where(user: current_user).delete_all
    Airline.where(user: current_user).delete_all
  end

  def load_data_from_seed_file
    @data = JSON.parse(File.read(Rails.root.join('public', 'seed_data.json')))
  end

  def insert_airlines
    @airline_ids = {}
    @data['airlines'].each do |p|
      pp = p.clone
      pp['user_id'] = current_user.id
      airline = Airline.create!(pp.except 'id')
      @airline_ids[pp['id']] = airline.id
    end
  end

  def insert_airports
    @airport_ids = {}
    @data['airports'].each do |p|
      pp = p.clone
      pp['user_id'] = current_user.id
      airport = Airport.create!(pp.except 'id')
      @airport_ids[pp['id']] = airport.id
    end
  end

  def insert_planes
    @plane_ids = {}
    @data['planes'].each do |p|
      pp = p.clone
      pp['user_id'] = current_user.id
      plane = Plane.create!(pp.except 'id')
      @plane_ids[pp['id']] = plane.id
    end
  end

  def insert_flights
    @flight_ids = {}
    @data['flights'].each do |p|
      pp = p.clone
      pp['user_id'] = current_user.id
      pp['departure_id'] = @airport_ids[pp['departure_id']]
      pp['arrival_id']   = @airport_ids[pp['arrival_id']]
      pp['airline_id']   = @airline_ids[pp['airline_id']]
      pp['plane_id']     = @plane_ids[pp['plane_id']]
      flight = Flight.create!(pp.except 'id')
      @flight_ids[pp['id']] = flight.id
    end
  end

  def insert_instances
    @instance_ids = {}
    @data['instances'].each do |p|
      pp = p.clone
      pp['user_id'] = current_user.id
      pp['flight_id'] = @flight_ids[pp['flight_id']]
      instance = Instance.create!(pp.except 'id')
      @instance_ids[pp['id']] = instance.id
    end
  end

  def insert_seats
    @seat_ids = {}
    @data['seats'].each do |p|
      pp = p.clone
      pp['user_id'] = current_user.id
      pp['plane_id'] = @plane_ids[pp['plane_id']]
      seat = Seat.create!(pp.except 'id')
      @seat_ids[pp['id']] = seat.id
    end
  end
end