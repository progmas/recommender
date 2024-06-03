class Comment < ApplicationRecord
  self.primary_key = :id
  belongs_to :user
  belongs_to :product, optional: true
  belongs_to :order, optional: true
end
