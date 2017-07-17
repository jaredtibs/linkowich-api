class AddCurrentToLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :current, :boolean, default: false
  end
end
