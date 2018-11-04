class AirportsController < ApplicationController
  before_action :load_airport, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]



  ## GET /airports
  def index
    @airports = Airport
      .where(filter_params)
      .where(records_are_accessible)
      .order(sort_params)
      .page(pagination_number)
      .per(pagination_size)
    render json: @airports,
      include: include_params,
      meta: { pagination: pagination_meta(@airports) }
  end



  ## GET /airports/:id
  def show
    authorize @airport
    render json: @airport
  end



  ## POST /airports
  def create
    @airport = Airport.new(airport_params)
    @airport.user = current_user
    authorize @airport
    @airport.save!
    render json: @airport, status: :created
  end



  ## PUT/PATCH /airports/:id
  def update
    @airport.assign_attributes(airport_params)
    authorize @airport
    @airport.save!
    render json: @airport
  end



  ## DELETE /airports/:id
  def destroy
    authorize @airport
    @airport.destroy
    render json: @airport
  end



  private
    def airport_params
      params.require(:airport).permit(
        'name',
        'code',
        'latitude',
        'longitude',
        'city',
        'state',
        'city_url',
      )
    end

    def include_params
      params[:include].split(',') & [
        #'arrivals',
        #'departures',
      ] rescue nil
    end

    def filter_params
      params.require(:filter).permit(
        'code',
        'state',
        id: [],
      ) rescue nil
    end

    def sorting_whitelist
      [
        'id',
        'name',
        'code',
        'latitude',
        'longitude',
        'city',
        'state',
        'created_at',
        'updated_at'
      ]
    end

    def load_airport
      @airport = Airport.find(params[:id])
    end
end