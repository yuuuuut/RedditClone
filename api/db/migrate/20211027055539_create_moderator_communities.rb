class CreateModeratorCommunities < ActiveRecord::Migration[6.1]
  def change
    create_table :moderator_communities do |t|
      t.references :user, index: false
      t.references :community, type: :string
      t.timestamps
    end

    add_index :moderator_communities, [:user_id, :community_id], unique: true
  end
end
