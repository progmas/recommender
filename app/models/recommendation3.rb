class Recommendation3
  def self.popular_recommendations_by_order_date
    # 1. Sipariş verilerini çekme
    orders = Order.select(:product_id, :quantity, :created_at)

    # 2. Ürünlerin popülerlik ve tarih bilgilerini hesaplama
    product_data = orders.group_by(&:product_id).map do |product_id, product_orders|
      total_quantity = product_orders.sum(&:quantity)
      latest_order_date = product_orders.max_by(&:created_at).created_at
      [product_id, total_quantity, latest_order_date]
    end

    # 3. Sıralama ve en popüler 10 ürünü seçme
    sorted_products = product_data.sort_by { |_, quantity, date| [-quantity, -date] }.first(10)

    # 4. Önerilen ürünlerin ID'lerini döndürme
    sorted_products.map(&:first)
  end
end