class AddRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :routes do |t|
      t.references :start_station
      t.references :finish_station
      t.integer :weekday, options: "CHECK (weekday) BETWEEN 0 and 6"
      t.integer :departure_hours, options: "CHECK (weekday) BETWEEN 0 and 23"
      t.integer :departure_minutes, options: "CHECK (weekday) BETWEEN 0 and 59"
      t.integer :arrival_hours, options: "CHECK (weekday) BETWEEN 0 and 23"
      t.integer :arrival_minutes, options: "CHECK (weekday) BETWEEN 0 and 59"
      t.references :carrier
    end
  end
end
