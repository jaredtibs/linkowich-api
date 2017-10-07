class AddUpVoteCountToLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :upvote_count, :integer, default: 0
  end
end
