class CreateCommunityModerators < ActiveRecord::Migration[6.1]
  def change
    create_table :community_moderators do |t|
      t.references :moderator, index: false, foreign_key: { to_table: :users }
      t.references :community, type: :string
      t.timestamps
    end

    add_index :community_moderators, [:moderator_id, :community_id], unique: true
  end
end
