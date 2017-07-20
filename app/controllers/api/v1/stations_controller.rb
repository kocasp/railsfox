class API::V1::StationsController < API::V1::ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  def index
    render json: Station.all.to_json
  end
end
