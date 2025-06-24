require "test_helper"

class SeriesCollectionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get series_collection_index_url
    assert_response :success
  end
end
