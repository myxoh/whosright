class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.integer :user_id
      t.string :header
      t.text :body
      t.integer :discussion_type_id
      t.integer :score
      t.integer :topic_id

      t.timestamps null: false
    end
  end
end
