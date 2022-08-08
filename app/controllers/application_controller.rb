class ApplicationController < ActionController::API
    # include ActionController::Serialization
    include TokenFilter
    before_action :pre_authorize
end
