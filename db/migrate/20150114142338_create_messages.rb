class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.time :created_at
      t.integer :followers
      t.string :message
      t.float :sentiment
      t.time :updated_at
      t.string :user_handle

      t.timestamps
    end
  end
end
