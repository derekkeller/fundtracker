require 'test_helper'

class FundsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
