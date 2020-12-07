class Removelocationfrommachines < ActiveRecord::Migration[5.2]
  def change
    change_table(:machines) do |t|
      t.remove :location
      t.remove :designer
    end
  end
end
