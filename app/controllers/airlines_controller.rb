class AirlinesController < ApplicationController
  before_action :load_airline, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]



  ## GET /airlines
  def index
    @airlines = Airline
      .where(filter_params)
      .where(records_are_accessible)
      .order(sort_params)
      .page(pagination_number)
      .per(pagination_size)
    render json: @airlines,
      include: include_params,
      meta: { pagination: pagination_meta(@airlines) }
  end



  ## GET /airlines/:id
  def show
    authorize @airline
    render json: @airline
  end



  ## POST /airlines
  def create
    @airline = Airline.new(airline_params)
    @airline.user = current_user
    authorize @airline
    @airline.save!
    render json: @airline, status: :created
  end



  ## PUT/PATCH /airlines/:id
  def update
    @airline.assign_attributes(airline_params)
    authorize @airline
    @airline.save!
    render json: @airline
  end



  ## DELETE /airlines/:id
  def destroy
    authorize @airline
    @airline.destroy
    render json: @airline
  end



  private
    def airline_params
      params.require(:airline).permit(
        'name',
        'logo_url',
        'info',
      )
    end

    def include_params
      params[:include].split(',') & [
        #'planes',
        #'flights',
      ] rescue nil
    end

    def filter_params
      params.require(:filter).permit(
        id: [],
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

    def load_airline
      @airline = Airline.find(params[:id])
    end
end