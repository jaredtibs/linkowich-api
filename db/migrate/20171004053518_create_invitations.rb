class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.integer :sender_id, index: true, foreign_key: true
      t.string  :recipient_email, index: true
      t.boolean :viewed, default: false
      t.boolean :accepted, default: false

      t.timestamps
    end
  end
end
