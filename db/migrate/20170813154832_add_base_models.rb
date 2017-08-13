class AddBaseModels < ActiveRecord::Migration[5.1]
  def change
    create_table(:stations) do |t|
      t.references :city
      t.string :name
    end

    create_table(:cities) do |t|
      t.string :name
    end

    create_table(:currencies) do |t|
      t.string :name
    end

    create_table(:carriers) do |t|
      t.string :name
    end

    create_table(:route_logs) do |t|
      t.references :start_station
      t.references :finish_station
      t.datetime :departure_date_time
      t.datetime :arrival_date_time
      t.references :carrier
      t.references :currency
      t.float :total_cost
    end
  end
end
