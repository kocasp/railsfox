class API::V1::ConnectionsController < API::V1::ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :set_connection, only: [:show]
  before_filter :add_allow_credentials_headers

  def index
    render json: Connection.includes(:station).all.to_json(only: [:id],include: {station: {only: :name}, connected_station: {only: :name}})
  end

  def show
    render json: @connection.courses.all.to_json(only: [:id, :price, :departure_time, :arrival_time])
  end

  def options
    head :status => 200, :'Access-Control-Allow-Headers' => 'accept, content-type'
  end

  private

  def set_connection
    @connection = Connection.find(params[:id])
  end

  def add_allow_credentials_headers
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#section_5
    #
    # Because we want our front-end to send cookies to allow the API to be authenticated
    # (using 'withCredentials' in the XMLHttpRequest), we need to add some headers so
    # the browser will not reject the response
    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
  end
end
