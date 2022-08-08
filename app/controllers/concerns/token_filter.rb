module TokenFilter
  extend ActiveSupport::Concern
  JWT_SECRET_KEY = ENV["JWT_SECRET_KEY"]

  def pre_authorize
    auth_header = request.headers["Authorization"]
    if auth_header.present?
      begin
        token = auth_header.split(" ").last
        decoded = jwt_decode token
        @current_user_id = decoded[:id]
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    end
  end

  def jwt_decode token
    decoded = JWT.decode(token, JWT_SECRET_KEY).first
    HashWithIndifferentAccess.new decoded
  end

  def current_user
    @current_user ||= super || User.find_by(id: @current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end

  def authenticate_user
    return if signed_in?
    head :unauthorized
  end
end
