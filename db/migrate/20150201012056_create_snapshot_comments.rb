class CreateSnapshotComments < ActiveRecord::Migration
  def change
    create_table :snapshot_comments do |t|
        t.references :user, index: true
        t.references :snapshot, index: true
        t.string :detail
        t.timestamps
    end
  end
end
