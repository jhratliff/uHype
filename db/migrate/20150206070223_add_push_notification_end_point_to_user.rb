class AddPushNotificationEndPointToUser < ActiveRecord::Migration
  def change
    add_column :users, :endpoint_arn, :string
  end
end
