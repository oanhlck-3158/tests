require 'faker'
require 'factory_bot_rails'

module UserHelpers
    def create_user
        FactoryBot.create(:user, 
                email: Faker::Internet.email, 
                password: "123456",
                password_confirmation: "123456"
            )
        end

    def build_user
        FactoryBot.build(:user, 
                email: Faker::Internet.email, 
                password: "123456",
                password_confirmation: "123456"
            )
    end

    # def invalid_user
    #     FactoryBot.build(:user, 

    #     )
    # end

end
