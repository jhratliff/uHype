class AddMediaFieldsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :media, :string
  end
end
