class AddSeenToSeries < ActiveRecord::Migration[7.1]
  def change
    add_column :series, :seen, :boolean
  end
end
