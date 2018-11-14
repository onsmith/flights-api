class UsersController < ApplicationController
  before_action :authenticate_user, only: [:index]


  ## GET /users
  def index
    render json: current_user
  end


  ## POST /users
  def create
    @user = User.new(user_params)
    @user.save!
    render json: @user, status: :created
  end



  private
    def user_params
      params.require(:user).permit(
        'username',
        'password',
      )
    end



    ## Handle ActionController exceptions
    rescue_from ActiveRecord::RecordNotUnique, with: :username_taken
    def username_taken(e)
      render json: {
        status: 409,
        error: 'Conflict',
        exception: 'A user with that username already exists in the database'
      }, status: :conflict
    end
end