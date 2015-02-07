class AddActionCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :action_code, :string
  end
end
