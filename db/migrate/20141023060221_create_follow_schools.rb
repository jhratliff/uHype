class CreateFollowSchools < ActiveRecord::Migration
  def change
    create_table :follow_schools do |t|
      t.references :user
      t.references :school
    end
  end
end
