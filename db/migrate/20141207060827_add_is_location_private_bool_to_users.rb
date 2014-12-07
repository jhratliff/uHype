class AddIsLocationPrivateBoolToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_location_private, :boolean, default: false
    add_column :users, :latitude, :string
    add_column :users, :longitude, :string
    add_column :users, :location_timestamp, :datetime

  end
end
