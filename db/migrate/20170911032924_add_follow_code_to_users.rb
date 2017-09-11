class AddFollowCodeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :follow_code, :string, unique: true
  end
end
