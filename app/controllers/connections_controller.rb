class ConnectionsController < ApplicationController
  before_action :set_connection, only: [:show]

  def index
    ConnectionWorker.perform_async(DateTime.now ,DateTime.now+4.days, Connection.first)
    if params[:connection].present?
      redirect_to connection_path(params[:connection])
      return
    end
    @connections = Connection.all
  end

  def show
    @courses = Course.where(connection: @connection).order(:departure_time).paginate(page: params[:page], :per_page => 20)
    @cheapest_price = Course.where(connection: @connection).minimum(:price)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_connection
      @connection = Connection.find(params[:id])
    end
end
