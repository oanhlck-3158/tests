class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable, :confirmable
        # :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  def generate_jwt
    JWT.encode({
      id: id, exp: Settings.digits.token_expiration_time.hours.from_now.to_i},
      ENV["JWT_SECRET_KEY"])
  end
end
