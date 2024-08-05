require "test_helper"

class ImageClassificationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get image_classification_index_url
    assert_response :success
  end

  test "should get classify" do
    get image_classification_classify_url
    assert_response :success
  end
end
