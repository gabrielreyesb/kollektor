class AddImdbIdToSeries < ActiveRecord::Migration[7.1]
  def change
    add_column :series, :imdb_id, :string
  end
end

class AddSnoozedAtToSeries < ActiveRecord::Migration[7.0]
  def change
    add_column :series, :snoozed_at, :datetime
  end
end
