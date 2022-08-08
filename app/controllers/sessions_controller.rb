class SessionsController < Devise::SessionsController
  respond_to :json
  before_action :sign_in_params, only: :create

  def create
    user = User.find_by email: sign_in_params[:email]

    if user && user.valid_password?(sign_in_params[:password])
      access_token = user.generate_jwt
      render json: {
        access_token: access_token,
        expiration_time: Settings.digits.token_expiration_time
      }
    else
      render json: {
        errors:  'email or password is invalid'
      }, status: :unauthorized
    end
  end

  private 
  
  def sign_in_params 
    params.require(:user).permit(:email, :password)
  end
end
