class Recommendation
  def self.item_based_recommendations(user_id)
    # 1. Kullanıcının satın aldığı ürünleri al
    user_products = Order.where(user_id: user_id).pluck(:product_id)

    # 2. Satın aldığı ürünlerin kategorileri
    user_products_categories = Product.where(id: user_products).pluck(:category_id)

    # 3. Bu ürünlere benzer ürünleri bul (Aynı kategori de olanlardan)
    similar_products = Product.where(category_id: user_products_categories).where.not(id: user_products).distinct

    # 4. Benzer ürünlerin satın alma sayısını hesapla
    similar_products_counts = Order.where(product_id: similar_products).group(:product_id).count

    # 5. En çok satın alınan benzer ürünleri öner
    recommended_products = similar_products_counts.sort_by { |_k, v| -v }.first(10).map { |k, _v| k }

    return recommended_products
  end
end