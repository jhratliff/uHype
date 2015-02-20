class AddVideoToSnapshots < ActiveRecord::Migration
  def change
    add_column :snapshots, :video, :string
  end
end
