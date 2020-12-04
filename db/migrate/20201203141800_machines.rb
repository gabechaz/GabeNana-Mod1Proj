class Machines < ActiveRecord::Migration[5.2]
  def change
    create_table :machines do |t|
      t.string :name
      t.string :location
      t.string :designer
    end
  end
end
