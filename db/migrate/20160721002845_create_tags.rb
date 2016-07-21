class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.text :name
      t.timestamps
    end

    create_table :clothing_tags do |t|
      t.integer :clothing_id
      t.integer :tag_id
    end

    add_index :tags, :name, unique: true
    add_index :clothing_tags, [:clothing_id, :tag_id], unique: true
  end
end
