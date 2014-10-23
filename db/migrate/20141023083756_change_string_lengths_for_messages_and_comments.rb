class ChangeStringLengthsForMessagesAndComments < ActiveRecord::Migration
  def change
    change_column :comments, :detail, :text
    change_column :messages, :detail, :text

  end
end
