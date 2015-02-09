class AddTimerLeftToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :timer_left, :integer
  end
end
