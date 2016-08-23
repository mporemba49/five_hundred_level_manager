class CreateRoyalties < ActiveRecord::Migration[5.0]
  def change
    create_table :royalties do |t|
      t.string :code, null: false
      t.string :league, null: false
      t.decimal :percentage, null: false

      t.timestamps
    end

    add_index :royalties, :code, unique: true
    add_index :royalties, :league, unique: true
  end
end
