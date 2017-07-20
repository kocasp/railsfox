class API::V1::ConnectionsController < API::V1::ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  def index
    render json: Connection.all.to_json
  end
end
