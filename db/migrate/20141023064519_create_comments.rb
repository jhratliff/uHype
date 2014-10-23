class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :school, index: true
      t.string :detail
      t.integer :flag_count
      t.integer :like_count
      t.integer :unlike_count

      t.timestamps
    end
  end
end
