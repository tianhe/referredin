class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :country
      t.string  :location
      t.string  :industry
      t.string  :headline
      t.string  :picture_url
      t.integer :user_id

      t.timestamps
    end
  end
end
