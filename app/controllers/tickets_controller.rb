class TicketsController < ApplicationController
  before_action :load_ticket, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]



  ## GET /tickets
  def index
    @tickets = Ticket
      .where(filter_params)
      .where(records_are_accessible)
      .order(sort_params)
      .page(pagination_number)
      .per(pagination_size)
    render json: @tickets,
      include: include_params,
      meta: { pagination: pagination_meta(@tickets) }
  end



  ## GET /tickets/:id
  def show
    authorize @ticket
    render json: @ticket
  end



  ## POST /tickets
  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.user = current_user
    authorize @ticket
    @ticket.save!
    render json: @ticket, status: :created
  end



  ## PUT/PATCH /tickets/:id
  def update
    @ticket.assign_attributes(ticket_params)
    authorize @ticket
    @ticket.save!
    render json: @ticket
  end



  ## DELETE /tickets/:id
  def destroy
    authorize @ticket
    @ticket.destroy
    render json: @ticket
  end



  private
    def ticket_params
      params.require(:ticket).permit(
        'first_name',
        'middle_name',
        'last_name',
        'age',
        'gender',
        'is_purchased',
        'price_paid',
        'instance_id',
        'itinerary_id',
        'seat_id',
        'info',
      )
    end

    def include_params
      params[:include].split(',') & [
        'instance',
        'itinerary',
        'seat',
      ] rescue nil
    end

    def filter_params
      params.require(:filter).permit(
        'first_name',
        'middle_name',
        'last_name',
        'age',
        'gender',
        'is_purchased',
        'price_paid',
        'instance_id',
        'itinerary_id',
        'seat_id',
        id: [],
      ) rescue nil
    end

    def sorting_whitelist
      [
        'id',
        'first_name',
        'middle_name',
        'last_name',
        'is_purchased',
        'price_paid',
        'created_at',
        'updated_at'
      ]
    end

    def load_ticket
      @ticket = Ticket.find(params[:id])
    end
end