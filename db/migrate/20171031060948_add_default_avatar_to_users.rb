class AddDefaultAvatarToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :default_avatar_color, :string
  end
end
