class CreateCommunities < ActiveRecord::Migration[6.1]
  def change
    create_table :communities do |t|
      t.string :name
      t.text :description
      t.string :main_image
      t.string :header_image
      t.string :color
      t.integer :limitation, default: 0, index: true
      t.timestamps
    end
  end
end
