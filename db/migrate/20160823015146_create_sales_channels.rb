class CreateSalesChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :sales_channels do |t|
      t.string :name, null: false
      t.string :sku, null: false
      t.decimal :percentage, null: false

      t.timestamps
    end

    add_index :sales_channels, :name, unique: true
    add_index :sales_channels, :sku, unique: true
  end
end
