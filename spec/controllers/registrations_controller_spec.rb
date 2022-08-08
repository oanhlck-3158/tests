require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do
    let (:user) {build_user}
    let (:existing_user) {create_user}
    
    let (:signup_path) {"/api/signup"}

    context "When creating a new user" do
        before do
            post signup_path, 
                params: {
                    email: user.email,
                    password: user.password,
                    password_confirmation: user.password_confirmation
                }
        end

        it "returns 200" do
            expect(response.status).to eq 200
        end

        # it "returns a token" do
        #     expect(response.headers['Authorization']).to be_present
        # end
    end

    context "When email already exists" do
        before do
            post signup_path,
                params: {
                    email: existing_user.email,
                    password: existing_user.password,
                    password_confirmation: existing_user.password_confirmation
                }
        end

        it "return 400" do
            expect(response).to have_http_status :bad_request
        end
    end
end
