class CreateUserCommunities < ActiveRecord::Migration[6.1]
  def change
    create_table :user_communities do |t|
      t.references :user, index: false
      t.references :community
      t.timestamps
    end

    add_index :user_communities, [:user_id, :community_id], unique: true
  end
end
