class AddSnapshotLikeUnlikeAndFlag < ActiveRecord::Migration
  def change
    create_table :snapshot_likes do |t|
      t.references :user
      t.references :snapshot
      t.timestamps
    end
    create_table :snapshot_unlikes do |t|
      t.references :user
      t.references :snapshot
      t.timestamps
    end
    create_table :snapshot_flags do |t|
      t.references :user
      t.references :snapshot
      t.timestamps
    end

  end
end
