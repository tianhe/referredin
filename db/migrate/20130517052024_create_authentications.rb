class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :uid
      t.string :token
      t.string :user_id

      t.timestamps
    end
  end
end
