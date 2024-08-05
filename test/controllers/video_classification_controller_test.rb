require "test_helper"

class VideoClassificationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get video_classification_index_url
    assert_response :success
  end

  test "should get classify" do
    get video_classification_classify_url
    assert_response :success
  end
end
