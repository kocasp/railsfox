class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :station_id
      t.integer :connected_station_id

      t.timestamps null: false
    end
  end
end
