class AddStatusToFollowing < ActiveRecord::Migration
  def change
    add_column :followings, :status, :text
  end
end
