class AddSchoolFollows < ActiveRecord::Migration
  def change

    create_table :school_follows do |t|
      t.belongs_to :user
      t.belongs_to :school
      t.timestamps
    end
  end
end
