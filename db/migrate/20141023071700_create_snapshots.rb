class CreateSnapshots < ActiveRecord::Migration
  def change
    create_table :snapshots do |t|
      t.string :URL
      t.integer :like_count
      t.integer :unlike_count
      t.integer :flag_count
      t.references :user, index: true

      t.timestamps
    end
  end
end
