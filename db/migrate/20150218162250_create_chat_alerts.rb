class CreateChatAlerts < ActiveRecord::Migration
  def change
    create_table :chat_alerts do |t|
      t.references :user, index: true
      t.integer :recipient_id
      t.integer :message_id
      t.timestamps
    end
  end
end
