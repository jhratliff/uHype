class AddPhotoToSnapshots < ActiveRecord::Migration
  def change
    add_column :snapshots, :photo, :string
  end
end
