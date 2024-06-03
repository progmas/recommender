class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.integer :kind
      t.integer :parent_id
      t.string :name
    end
  end
end
