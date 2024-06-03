class Product < ApplicationRecord
  self.primary_key = :id
  belongs_to :category
  belongs_to :user
  has_many :orders
  has_many :comments
end
