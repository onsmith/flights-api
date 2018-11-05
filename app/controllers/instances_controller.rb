class InstancesController < ApplicationController
  before_action :load_instance, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]



  ## GET /instances
  def index
    @instances = Instance
      .where(filter_params)
      .where(records_are_accessible)
      .order(sort_params)
      .page(pagination_number)
      .per(pagination_size)
    render json: @instances,
      include: include_params,
      meta: { pagination: pagination_meta(@instances) }
  end



  ## GET /instances/:id
  def show
    authorize @instance
    render json: @instance
  end



  ## POST /instances
  def create
    @instance = Instance.new(instance_params)
    @instance.user = current_user
    authorize @instance
    @instance.save!
    render json: @instance, status: :created
  end



  ## PUT/PATCH /instances/:id
  def update
    @instance.assign_attributes(instance_params)
    authorize @instance
    @instance.save!
    render json: @instance
  end



  ## DELETE /instances/:id
  def destroy
    authorize @instance
    @instance.destroy
    render json: @instance
  end



  private
    def instance_params
      params.require(:instance).permit(
        'flight_id',
        'date',
        'is_cancelled',
        'info',
      )
    end

    def include_params
      params[:include].split(',') & [
        'flight',
        #'tickets',
      ] rescue nil
    end

    def filter_params
      params.require(:filter).permit(
        'date',
        'is_cancelled',
        id: [],
      ) rescue nil
    end

    def sorting_whitelist
      [
        'id',
        'date',
        'is_cancelled',
        'created_at',
        'updated_at'
      ]
    end

    def load_instance
      @instance = Instance.find(params[:id])
    end
end