class Games < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :score
    end
  end
end
