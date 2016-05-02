class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.timestamp :birthdate
      t.text :description

      t.timestamps null: false
    end
  end
end
