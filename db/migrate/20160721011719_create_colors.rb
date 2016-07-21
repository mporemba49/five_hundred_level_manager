class CreateColors < ActiveRecord::Migration[5.0]
  def change
    create_table :colors do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :colors, :name, unique: true
  end
end
