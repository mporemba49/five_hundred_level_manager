class CreateRoyalties < ActiveRecord::Migration[5.0]
  def change
    create_table :royalties do |t|
      t.string :code, null: false
      t.string :agreement

      t.timestamps
    end

    add_index :royalties, :code, unique: true
  end
end
