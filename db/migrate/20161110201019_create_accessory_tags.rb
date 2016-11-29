class CreateAccessoryTags < ActiveRecord::Migration[5.0]
  def change
    create_table :accessory_tags do |t|
      t.integer :accessory_id
      t.integer :tag_id
    end

    add_index :accessory_tags, [:accessory_id, :tag_id], unique: true
  end
end
