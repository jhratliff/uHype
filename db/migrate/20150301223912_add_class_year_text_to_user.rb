class AddClassYearTextToUser < ActiveRecord::Migration
  def change
    add_column :users, :year_text, :string
  end
end
