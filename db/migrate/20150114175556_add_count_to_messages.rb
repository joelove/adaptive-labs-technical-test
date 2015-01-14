class AddCountToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :count, :integer
  end
end
