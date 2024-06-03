class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.datetime :created_at
      t.datetime :last_seen
    end
  end
end
