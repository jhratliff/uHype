class AddFollowing < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.references :user
      t.integer :followed_id
      t.timestamps
    end
  end
end
