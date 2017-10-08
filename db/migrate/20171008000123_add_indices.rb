class AddIndices < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :follow_code, unique: true

    add_index :invitations, [:sender_id, :recipient_email], unique: true
  end
end
