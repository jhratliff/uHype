class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, index: true
      t.integer :recipient_id
      t.string :detail
      t.integer :flag_count
      t.timestamps
    end
  end
end
