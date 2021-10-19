class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :text
      t.string :url
      t.boolean :spoiler, default: false, null: false
      t.boolean :nsfw, default: false, null: false
      t.integer :status, default: 0
      t.integer :type, default: 0
      t.references :user, index: true

      t.timestamps
    end
  end
end
