class SessionsController < ApplicationController
  ## POST /sessions
  def create
    user = User.find_for_authentication(username: login_params[:username])

    if user.present? && user.valid_password?(login_params[:password])
      sign_in user
    else
      head :unauthorized
    end
  end

  ## DELETE /sessions
  def destroy
    if user_signed_in?
      sign_out current_user
    end
  end



  private
    def login_params
      params.require(:user).permit(
        :username,
        :password
      )
    end
end