class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.integer :kind
      t.references :category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name
    end
  end
end
