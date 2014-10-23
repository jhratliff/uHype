class AddCommentLikes < ActiveRecord::Migration
  def change
    create_table :comment_likes do |t|
      t.references :user
      t.references :comment
      t.timestamps
    end
    create_table :comment_unlikes do |t|
      t.references :user
      t.references :comment
      t.timestamps
    end
    create_table :comment_flags do |t|
      t.references :user
      t.references :comment
      t.timestamps
    end
  end
end
