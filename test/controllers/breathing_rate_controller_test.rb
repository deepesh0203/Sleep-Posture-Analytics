require "test_helper"

class BreathingRateControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get breathing_rate_index_url
    assert_response :success
  end

  test "should get calculate" do
    get breathing_rate_calculate_url
    assert_response :success
  end
end
