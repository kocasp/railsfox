class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.datetime :departure_time
      t.datetime :arrival_time
      t.integer :connection_id

      t.timestamps null: false
    end
  end
end
