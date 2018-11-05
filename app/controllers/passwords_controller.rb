class PasswordsController < ApplicationController
  ## PUT/PATCH /password
  def update
    user = User.find_for_authentication(username: password_params[:username])
    if user.present? && user.valid_password?(password_params[:old_password])
      user.password = password_params[:new_password]
      user.save!
    else
      head :unauthorized
    end
  end


  private
    def password_params
      params.require(:user).permit(
        :username,
        :old_password,
        :new_password
      )
    end
end