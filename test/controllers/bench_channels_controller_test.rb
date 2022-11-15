require "test_helper"

class BenchChannelsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get bench_channels_create_url
    assert_response :success
  end
end
