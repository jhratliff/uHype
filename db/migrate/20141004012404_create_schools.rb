class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.text :maplink
      t.string :stype
      t.string :grades
      t.string :website

      t.timestamps
    end
  end
end
