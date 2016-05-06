class CreateDiscussionTypes < ActiveRecord::Migration
  def change
    create_table :discussion_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
