class SeatsController < ApplicationController
  before_action :load_seat, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]



  ## GET /seats
  def index
    @seats = Seat
      .where(filter_params)
      .where(records_are_accessible)
      .order(sort_params)
      .page(pagination_number)
      .per(pagination_size)
    render json: @seats,
      include: include_params,
      meta: { pagination: pagination_meta(@seats) }
  end



  ## GET /seats/:id
  def show
    authorize @seat
    render json: @seat
  end



  ## POST /seats
  def create
    @seat = Seat.new(seat_params)
    @seat.user = current_user
    authorize @seat
    @seat.save!
    render json: @seat, status: :created
  end



  ## PUT/PATCH /seats/:id
  def update
    @seat.assign_attributes(seat_params)
    authorize @seat
    @seat.save!
    render json: @seat
  end



  ## DELETE /seats/:id
  def destroy
    authorize @seat
    @seat.destroy
    render json: @seat
  end



  private
    def seat_params
      params.require(:seat).permit(
        'plane_id',
        'row',
        'number',
        'class',
        'is_window',
        'is_isle',
        'is_exit',
      )
    end

    def include_params
      params[:include].split(',') & [
        'plane',
        #'tickets',
      ] rescue nil
    end

    def filter_params
      params.require(:filter).permit(
        'plane_id',
        'row',
        'number',
        'class',
        'is_window',
        'is_isle',
        'is_exit',
        id: [],
      ) rescue nil
    end

    def sorting_whitelist
      [
        'id',
        'plane_id',
        'row',
        'number',
        'class',
        'is_window',
        'is_isle',
        'is_exit',
        'created_at',
        'updated_at'
      ]
    end

    def load_seat
      @seat = Seat.find(params[:id])
    end
end