class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.date :sent
      t.text :comments
      t.string :status
      t.references :requisition, foreign_key: true

      t.timestamps
    end
  end
end
