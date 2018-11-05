class ItinerariesController < ApplicationController
  before_action :load_itinerary, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]



  ## GET /itineraries
  def index
    @itineraries = Itinerary
      .where(filter_params)
      .where(records_are_accessible)
      .order(sort_params)
      .page(pagination_number)
      .per(pagination_size)
    render json: @itineraries,
      include: include_params,
      meta: { pagination: pagination_meta(@itineraries) }
  end



  ## GET /itineraries/:id
  def show
    authorize @itinerary
    render json: @itinerary
  end



  ## POST /itineraries
  def create
    @itinerary = Itinerary.new(itinerary_params)
    @itinerary.user = current_user
    authorize @itinerary
    @itinerary.save!
    render json: @itinerary, status: :created
  end



  ## PUT/PATCH /itineraries/:id
  def update
    @itinerary.assign_attributes(itinerary_params)
    authorize @itinerary
    @itinerary.save!
    render json: @itinerary
  end



  ## DELETE /itineraries/:id
  def destroy
    authorize @itinerary
    @itinerary.destroy
    render json: @itinerary
  end



  private
    def itinerary_params
      params.require(:itinerary).permit(
        'confirmation_code',
        'email',
        'info',
      )
    end

    def include_params
      params[:include].split(',') & [
        #'tickets',
      ] rescue nil
    end

    def filter_params
      params.require(:filter).permit(
        'email',
        'confirmation_code',
        id: [],
      ) rescue nil
    end

    def sorting_whitelist
      [
        'id',
        'email',
        'confirmation_code',
        'created_at',
        'updated_at'
      ]
    end

    def load_itinerary
      @itinerary = Itinerary.find(params[:id])
    end
end