class User < ApplicationRecord
	self.primary_key = :id
	has_many :orders
	has_many :comments
	has_many :products, through: :orders # Kullanıcının satın aldığı ürünler
end
