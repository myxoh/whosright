class AddBooleanPublishedToDiscussions < ActiveRecord::Migration
  def change
    add_column  :discussions, :published, :boolean
  end
end
