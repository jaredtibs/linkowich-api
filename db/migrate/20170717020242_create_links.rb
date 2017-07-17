class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.integer :user_id, foreign_key: true, index: true
      t.string  :url, null: false
      t.integer :seen_by, array: true, default: []

      t.timestamps null: false
    end
  end
end
