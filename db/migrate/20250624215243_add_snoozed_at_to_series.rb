class AddSnoozedAtToSeries < ActiveRecord::Migration[7.1]
  def change
    add_column :series, :snoozed_at, :datetime
  end
end
