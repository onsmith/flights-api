class PlanesController < ApplicationController
  before_action :load_plane, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]



  ## GET /planes
  def index
    @planes = Plane
      .where(filter_params)
      .where(records_are_accessible)
      .order(sort_params)
      .page(pagination_number)
      .per(pagination_size)
    render json: @planes,
      include: include_params,
      meta: { pagination: pagination_meta(@planes) }
  end



  ## GET /planes/:id
  def show
    authorize @plane
    render json: @plane
  end



  ## POST /planes
  def create
    @plane = Plane.new(plane_params)
    @plane.user = current_user
    authorize @plane
    @plane.save!
    render json: @plane, status: :created
  end



  ## PUT/PATCH /planes/:id
  def update
    @plane.assign_attributes(plane_params)
    authorize @plane
    @plane.save!
    render json: @plane
  end



  ## DELETE /planes/:id
  def destroy
    authorize @plane
    @plane.destroy
    render json: @plane
  end



  private
    def plane_params
      params.require(:plane).permit(
        'name',
        'seatmap_url',
        'airline_id',
      )
    end

    def include_params
      params[:include].split(',') & [
        'airline',
        #'flights',
        #'seats',
      ] rescue nil
    end

    def filter_params
      params.require(:filter).permit(
        'name',
        'airline_id',
        id: [],
      ) rescue nil
    end

    def sorting_whitelist
      [
        'id',
        'name',
        'airline_id',
        'created_at',
        'updated_at'
      ]
    end

    def load_plane
      @plane = Plane.find(params[:id])
    end
end