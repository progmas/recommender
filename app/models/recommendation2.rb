# app/models/recommendation.rb

class Recommendation2
  def self.rating_based_recommendations(user_id)
    # 1. Kullanıcının puan verdiği ürünleri ve puanlarını al
    user_ratings = Comment.where(user_id: user_id).pluck(:product_id, :rating)
    return [] if user_ratings.empty? # Kullanıcının puan verdiği ürün yoksa boş bir dizi döndür

    # 2. Diğer kullanıcıların bu ürünlere verdiği puanları al
    other_ratings = Comment.where(product_id: user_ratings.map(&:first)).where.not(user_id: user_id)

    # 3. Ürün benzerliklerini hesapla (Pearson korelasyonu)
    item_ids = user_ratings.map(&:first) + other_ratings.pluck(:product_id).uniq
    user_ids = User.limit(1000).ids
    data_matrix = Matrix.build(item_ids.size, user_ids.size) do |row, col|
      rating = other_ratings.find { |r| r.product_id == item_ids[row] && r.user_id == user_ids[col] }&.rating
      rating || 0
    end
    pearson_correlation = RubyML::Distance::PearsonCorrelation.new
    similarity_matrix = pearson_correlation.pairwise(data_matrix.transpose) # Ürünler arası benzerlik için transpoz al

    # 4. Kullanıcının puan vermediği ürünlere tahmini puanlar hesapla
    product_scores = Hash.new(0)
    user_ratings.each do |product_id, user_rating|
      item_index = item_ids.index(product_id)
      similarities = similarity_matrix.row(item_index)
      other_ratings.each do |other_rating|
        next if other_rating.product_id == product_id
        other_item_index = item_ids.index(other_rating.product_id)
        product_scores[other_rating.product_id] += user_rating * similarities[other_item_index]
      end
    end

    # 5. En yüksek tahmini puanlı ürünleri öner
    recommended_products = product_scores.sort_by { |_k, v| -v }.first(10).map(&:first)

    return recommended_products
  end
end