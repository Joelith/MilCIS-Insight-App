class CreateRequisitions < ActiveRecord::Migration[5.0]
  def change
    create_table :requisitions do |t|
      t.string :title
      t.text :description
      t.float :amount
      t.string :status
      t.string :loc

      t.timestamps
    end
  end
end
