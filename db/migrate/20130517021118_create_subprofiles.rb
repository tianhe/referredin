class CreateSubprofiles < ActiveRecord::Migration
  def change
    create_table :subprofiles do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :country
      t.string  :location
      t.string  :industry
      t.string  :headline
      t.string  :picture_url
      t.integer :profile_id
      t.string  :public_profile_url
      t.string  :provider
      t.string  :identifier
      t.text :specialties
      t.text :summary
      t.integer :num_connections

      t.timestamps
    end
  end
end
