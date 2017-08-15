class ChangeWeekdayColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :routes, :weekday
    add_column :routes, :monday, :boolean, default: false
    add_column :routes, :tuesday, :boolean, default: false
    add_column :routes, :wednesday, :boolean, default: false
    add_column :routes, :thursday, :boolean, default: false
    add_column :routes, :friday, :boolean, default: false
    add_column :routes, :saturday, :boolean, default: false
    add_column :routes, :sunday, :boolean, default: false
  end
end
