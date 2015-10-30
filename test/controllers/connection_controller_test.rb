require 'test_helper'

class ConnectionControllerTest < ActionController::TestCase
  test "should get station_id:integer" do
    get :station_id:integer
    assert_response :success
  end

  test "should get connected_station_id:integer" do
    get :connected_station_id:integer
    assert_response :success
  end

end
