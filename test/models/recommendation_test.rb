# test/models/recommendation_test.rb

require "test_helper"

class RecommendationTest < ActiveSupport::TestCase
  test "item_based_recommendations" do
    user_id = 294253
    expected_recommendations =[43457, 75083, 153975, 25, 105186, 89, 153976, 1065289, 75084, 1065295] # Beklenen öneriler (örnek)
    actual_recommendations = Recommendation.item_based_recommendations(user_id)
    assert_equal expected_recommendations, actual_recommendations
  end
end