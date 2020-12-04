class ExpelTables < ActiveRecord::Migration[5.2]
  def change
    change_table(:machines) do |t|
      t.remove :location
      r.remove :designer
  end
end
