class CreateCommunities < ActiveRecord::Migration[6.1]
  def change
    create_table :communities, id: false do |t|
      t.string :name, null: false, primary_key: true
      t.text :description
      t.string :main_image
      t.string :header_image
      t.integer :color, default: 0
      t.integer :header_height, default: 0
      t.integer :limitation, default: 0, index: true
      t.string :path
      t.timestamps
    end
  end
end
