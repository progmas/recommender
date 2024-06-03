class Order < ApplicationRecord
  self.primary_key = :id
  belongs_to :user
  belongs_to :product
end
