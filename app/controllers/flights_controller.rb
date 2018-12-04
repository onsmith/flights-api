class FlightsController < ApplicationController
  before_action :load_flight, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]



  ## GET /flights
  def index
    @flights = Flight
      .filter(scope_params)
      .where(filter_params)
      .where(records_are_accessible)
      .order(sort_params)
      .page(pagination_number)
      .per(pagination_size)
    render json: @flights,
      include: include_params,
      meta: { pagination: pagination_meta(@flights) }
  end



  ## GET /flights/:id
  def show
    authorize @flight
    render json: @flight
  end



  ## POST /flights
  def create
    @flight = Flight.new(flight_params)
    @flight.user = current_user
    authorize @flight
    @flight.save!
    render json: @flight, status: :created
  end



  ## PUT/PATCH /flights/:id
  def update
    @flight.assign_attributes(flight_params)
    authorize @flight
    @flight.save!
    render json: @flight
  end



  ## DELETE /flights/:id
  def destroy
    authorize @flight
    @flight.destroy
    render json: @flight
  end



  private
    def flight_params
      params.require(:flight).permit(
        'departs_at',
        'arrives_at',
        'number',
        'plane_id',
        'departure_id',
        'arrival_id',
        'next_flight_id',
        'airline_id',
        'info',
      )
    end

    def include_params
      params[:include].split(',') & [
        'plane',
        'departure',
        'arrival',
        'next_flight',
        'airline',
        #'last_flight',
        #'instances',
      ] rescue nil
    end

    def filter_params
      params.require(:filter).permit(
        'departs_at',
        'arrives_at',
        'number',
        'plane_id',
        'departure_id',
        'arrival_id',
        'next_flight_id',
        'airline_id',
        'info',
        id: [],
      ) rescue nil
    end

    def scope_params
      params.require(:filter).permit(
        'departs_at_lt',
        'departs_at_gt',
        'departs_at_le',
        'departs_at_ge',
        'departs_at_eq',
        'departs_at_ne',
      ) rescue nil
    end

    def sorting_whitelist
      [
        'id',
        'name',
        'created_at',
        'updated_at'
      ]
    end

    def load_flight
      @flight = Flight.find(params[:id])
    end
end