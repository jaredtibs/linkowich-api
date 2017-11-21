class AddHiddenToLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :hidden, :boolean, default: false
  end
end
