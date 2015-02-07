class AddVersionNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :version_number, :string
    add_column :users, :status_code, :string

  end
end
