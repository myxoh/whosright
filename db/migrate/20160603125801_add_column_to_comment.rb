class AddColumnToComment < ActiveRecord::Migration
  def change
    add_column :comments, :score, :integer
  end
end
