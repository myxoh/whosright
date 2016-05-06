class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.references :discussion, index: true, foreign_key: true
      t.string :email
      t.string :name
      t.text :body
      t.integer :score

      t.timestamps null: false
    end
  end
end
