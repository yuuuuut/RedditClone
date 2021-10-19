class CreatePostImages < ActiveRecord::Migration[6.1]
  def change
    create_table :post_images do |t|
      t.references :post
      t.text :uid
      t.text :url

      t.timestamps
    end
  end
end
