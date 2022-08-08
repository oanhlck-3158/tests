class RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  before_action :sign_up_params, :check_existed_user, only: :create
  respond_to :json

  private 

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def check_existed_user
    @existed_user = User.find_by email: sign_up_params[:email]
    if @existed_user 
      render json: {
        message: "nohope"
      }, status: :unprocessable_entity
    end
  end
end
